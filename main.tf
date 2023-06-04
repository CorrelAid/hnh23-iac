module "docker_host" {
  source              = "./docker_host"
  smtp_pw             = var.smtp_pw
  smtp_user           = var.smtp_user
  directus_admin_pw   = var.directus_admin_pw
  directus_admin_mail = var.directus_admin_mail
  ssh_key             = var.ssh_key
}

provider "docker" {
  host     = "ssh://root@${module.docker_host.host_ip}:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null", "-i", "<(echo ${module.docker_host.ssh_key})"]
}

module "docker_containers" {
  source = "./docker_containers"
  depends_on = [
    module.docker_host
  ]
  host_ip = module.docker_host.host_ip
  ssh_key = module.docker_host.ssh_key
 
}
