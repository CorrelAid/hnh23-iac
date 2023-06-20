# Optional configuration
variable "server" {
  type        = map(any)
  description = "Server configuration map"
  default = {
    name        = "docker-host"
    server_type = "ccx12"
    image       = "ubuntu-22.04"
    location    = "nbg1"
    backups     = true
    user = "user"
  }
}

variable "docker_compose_version" {
  type        = string
  description = "Docker compose version to install"
  default     = "2.17.3" # https://github.com/docker/compose/releases/latest
} 


variable "ssh_key"{

}

variable "machine_ssh_key_public"{

}

variable "zone" {
  default = "correlaid.org"
}


variable "directus_domain"{
  type = string
  default = "hackandharvest"
}


variable "ssh_key_name_user"{
  default = "default"
}

variable "ssh_key_name_machine"{
  default = "machine"
}