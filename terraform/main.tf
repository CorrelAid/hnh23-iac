data "hetznerdns_zone" "dns_zone" {
  name = var.zone
}

resource "hcloud_firewall" "firewall" {
  name = "docker_host"
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "80"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "443"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

}

resource "hcloud_ssh_key" "main" {
  name       = var.ssh_key_name
  public_key = var.ssh_key
}

resource "hcloud_volume" "main" {
  name      = "docker_data_volume"
  size      = var.volume_size
  location  = var.server.location
  automount = false
  format    = var.volume_filesystem
}

# Create server for deployment
resource "hcloud_server" "main" {
  name         = var.server.name
  image        = var.server.image
  server_type  = var.server.server_type
  location     = var.server.location
  backups      = var.server.backups
  firewall_ids = [hcloud_firewall.firewall.id]
  ssh_keys     = [var.ssh_key_name]
  user_data    = <<EOF
#cloud-config
locale: en_US.UTF-8
timezone: Europe/Berlin
package_update: true
package_upgrade: true
package_reboot_if_required: false
manage_etc_hosts: true
locale: en_US.UTF-8
timezone: Europe/Berlin


packages:
  - apt-transport-https
  - ca-certificates
  - curl
  - gnupg-agent
  - software-properties-common
  - fail2ban
  - unattended-upgrades

runcmd:
  - mkfs.${var.volume_filesystem} ${var.volume_filesystem == "xfs" ? "-f" : "-F"} ${hcloud_volume.main.linux_device}
  - mkdir /mnt/${hcloud_volume.main.name}
  - mount -o discard,defaults ${hcloud_volume.main.linux_device} /mnt/${hcloud_volume.main.name}
  - echo '${hcloud_volume.main.linux_device} /mnt/${hcloud_volume.main.name} ${var.volume_filesystem} discard,nofail,defaults 0 0' >> /etc/fstab
  - install -m 0755 -d /etc/apt/keyrings
  - curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  - chmod a+r /etc/apt/keyrings/docker.gpg
  - echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
  - apt-get update -y
  - apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin a
  - printf "[sshd]\nenabled = true\nbanaction = iptables-multiport" > /etc/fail2ban/jail.local
  - systemctl enable fail2ban
  - apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  - sed -i -e '/^\(#\|\)PermitRootLogin/s/^.*$/PermitRootLogin no/' /etc/ssh/sshd_config
  - sed -i -e '/^\(#\|\)PasswordAuthentication/s/^.*$/PasswordAuthentication no/' /etc/ssh/sshd_config
  - sed -i -e '/^\(#\|\)X11Forwarding/s/^.*$/X11Forwarding no/' /etc/ssh/sshd_config
  - sed -i -e '/^\(#\|\)MaxAuthTries/s/^.*$/MaxAuthTries 2/' /etc/ssh/sshd_config
  - sed -i -e '/^\(#\|\)AllowTcpForwarding/s/^.*$/AllowTcpForwarding no/' /etc/ssh/sshd_config
  - sed -i -e '/^\(#\|\)AllowAgentForwarding/s/^.*$/AllowAgentForwarding no/' /etc/ssh/sshd_config
  - sed -i -e '/^\(#\|\)AuthorizedKeysFile/s/^.*$/AuthorizedKeysFile .ssh\/authorized_keys/' /etc/ssh/sshd_config
  - sed -i '$a AllowUsers holu' /etc/ssh/sshd_config
  - sed -i -e "s|ExecStart=/usr/bin/dockerd|ExecStart=/usr/bin/dockerd --data-root=/mnt/${hcloud_volume.main.name}|g" /lib/systemd/system/docker.service
  - systemctl daemon-reload
  - systemctl restart docker
  - systemctl enable docker

final_message: "The system is ready, after $UPTIME seconds"

EOF
}

resource "hcloud_volume_attachment" "main" {
  volume_id = hcloud_volume.main.id
  server_id = hcloud_server.main.id
  automount = true
}

resource "hetznerdns_record" "main" {
  zone_id = data.hetznerdns_zone.dns_zone.id
  name    = var.directus_domain
  value   = hcloud_server.main.ipv4_address
  type    = "A"
}

#####################

# writing data to files for ansible

resource "random_password" "key" {
  length           = 40
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "secret" {
  length           = 40
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}



resource "github_repository_file" "hosts" {
  repository = "/hnh23_iac"
  branch     = "main"
  file       = "./ansible/hosts"
  content = templatefile("inventory.tmpl",
    {
      ip = hcloud_server.main.ipv4_address
    }
  )
  commit_message      = "Add hosts"
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}


resource "github_repository_file" "group_vars" {
  repository = "hnh23_iac"
  branch     = "main"
  file       = "./ansible/group_vars/main.yml"
  content = templatefile("group_vars.tmpl",
    {
      domain    = "${var.directus_domain}.${var.zone}"
      smtp_user = var.smtp_user
    }
  )
  commit_message      = "Add group_vars"
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}



