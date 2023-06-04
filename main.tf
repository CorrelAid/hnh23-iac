module "docker_host" {
  source              = "./docker_host"
  smtp_pw             = var.smtp_pw
  smtp_user           = var.smtp_user
  directus_admin_pw   = var.directus_admin_pw
  directus_admin_mail = var.directus_admin_mail
  ssh_key             = var.ssh_key
}

provider "docker" {
  alias    = "main"
  host     = "ssh://root@${hcloud_server.main.ipv4_address}:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null", "-i", "<(echo ${tls_private_key.ssh.private_key_pem})"]
}

module "docker_containers" {
  source = "./docker_containers"
  depends_on = [
    module.docker_host
  ]
  host_ip = module.docker_host.host_ip
  ssh_key = module.docker_host.ssh_key
  providers = {
    docker.main_ = docker.main
  }
}
