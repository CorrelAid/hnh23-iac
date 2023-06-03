
# Optional configuration
variable "server" {
  type        = map(any)
  description = "Server configuration map"
  default = {
    name        = "docker-host"
    server_type = "cx11"
    image       = "ubuntu-22.04"
    location    = "nbg1"
    backups     = false
  }
}

variable "sub_domain" {
  default = "basel-viz"
}

variable "zone" {
  default = "correlaid.org"
}

variable "git_user" {
  default = "correlaid"
}

variable "git_repo" {
  default = "jstet/basel_viz"
}

variable "smtp_pw"{
  type = string
}

variable "smtp_user" {
  type = string
}

variable "directus_admin_pw" {
  type = string
}

variable "directus_admin_mail" {
  type = string
}

variable "directus_domain"{
  type = string
  default = "kdb-cms"
}


