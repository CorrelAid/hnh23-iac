variable "ssh_key" {

}

variable "smtp_pw" {
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


variable "domain" {
  default = "kdb-cms.correlaid.org"
}

variable "machine_private_key" {
type = string
}

variable "machine_public_key" {
type = string
}