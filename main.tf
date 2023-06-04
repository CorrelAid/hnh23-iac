module "docker_host" {
  source = "./docker_host"
  smtp_pw = var.smtp_pw
  smtp_user = var.smtp_user 
  directus_admin_pw = var.directus_admin_pw 
  directus_admin_mail = var.directus_admin_mail
  ssh_key = var.ssh_key
  machine_public_key = var.machine_public_key
}


provider "docker" {
  host     = "ssh://root@${var.domain}:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null", "-i", "<(echo ${var.machine_private_key})"]
}

module "docker_containers" {
  source = "./docker_containers"
  depends_on = [
    module.module.docker_host
  ]

   
  
}