
variable "image_name" {
  default = "hnh23"
}

variable "ip_range" {
  default = "10.0.1.0/24"
}

variable "server_type" {
  default = "cx11"
}

variable "server_os" {
  default = "ubuntu-20.04"
}

variable "server_username" {
  default = "user"
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


