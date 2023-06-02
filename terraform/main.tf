data "hetznerdns_zone" "dns_zone" {
  name = var.zone
}



resource "hcloud_firewall" "firewall" {
  name = "my-firewall"
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

# Create server for deployment
resource "hcloud_server" "main" {
  name         = var.image_name
  image        = var.server_os
  server_type  = var.server_type
  firewall_ids = [hcloud_firewall.firewall.id]
  user_data    = <<EOF
#cloud-config

hostname: ${var.image_name}
manage_etc_hosts: true
locale: en_US.UTF-8
timezone: Europe/Berlin


users:
- default
- name: ${var.server_username}
  groups: sudo
  sudo: "ALL=(ALL) NOPASSWD:ALL"
  lock_passwd: true
  shell: /bin/bash
  ssh_authorized_keys:
    - ${file("~/.ssh/id_rsa.pub")}

EOF
}

resource "hetznerdns_record" "main" {
  zone_id = data.hetznerdns_zone.dns_zone.id
  name    = var.sub_domain
  value   = hcloud_server.main.ipv4_address
  type    = "A"
}

#####################

# writing data to files for ansible

resource "local_file" "ansible_vault" {
  content = templatefile("vault.tmpl",
    {
      db_connection_string = "postgres://postgres:${var.supabase_db_pw}@db.${var.supabase_project_id}.supabase.co/postgres?sslmode=require"
      wasabi_access_key    = var.wasabi_access_key
      wasabi_secret_key    = var.wasabi_secret_key
      wasabi_bucket        = var.wasabi_bucket
      directus_admin_pw    = var.directus_admin_pw
      directus_admin_mail  = var.directus_admin_mail
      directus_key         = var.directus_key
      directus_secret      = var.directus_secret
      smtp_password        = var.smtp_password

    }
  )
  filename = "../ansible/group_vars/vault.yml"

  provisioner "local-exec" {
    command = "ansible-vault encrypt ../ansible/group_vars/vault.yml --vault-password-file=../.vault_pw  -v "
  }
}


resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tmpl",
    {
      ip       = hcloud_server.main.ipv4_address
      username = var.server_username
    }
  )
  filename = "../ansible/hosts"
}

resource "local_file" "group_vars" {
  content = templatefile("group_vars.tmpl",
    {
      user      = var.server_username
      domain    = "${var.directus_domain}.${var.zone}"
      smtp_user = var.smtp_user
      git_user  = var.git_user
      git_repo  = var.git_repo
    }
  )
  filename = "../ansible/group_vars/main.yml"
}
