module "docker_host" {
  source = "./docker_host"
}


module "docker_containers" {
  source = "./docker_containers"
  depends_on = [
    module.module.docker_host
  ]
  host_ip = module.docker_host.host_ip
  ssh_key = module.docker_host.ssh_key
}