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

# Create server for deployment
resource "hcloud_server" "main" {
  name        = var.server.name
  image       = var.server.image
  server_type = var.server.server_type
  location    = var.server.location
  backups     = var.server.backups
  firewall_ids = [hcloud_firewall.firewall.id]
  ssh_keys    = file("~/.ssh/id_rsa.pub")
  user_data = templatefile("${path.module}/user_data/user-data.yaml", {
    docker_compose_version = var.docker_compose_version
    volume_filesystem      = var.volume_filesystem
    filesystem_cmd_opt     = var.volume_filesystem == "xfs" ? "-f" : "-F"
    linux_device           = hcloud_volume.master.linux_device
    mount_dir_name         = hcloud_volume.master.name
  })
}

resource "hetznerdns_record" "main" {
  zone_id = data.hetznerdns_zone.dns_zone.id
  name    = var.sub_domain
  value   = hcloud_server.main.ipv4_address
  type    = "A"
}