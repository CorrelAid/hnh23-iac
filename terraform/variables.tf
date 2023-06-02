
variable "image_name" {
  default = "hnh23"
}

variable "ip_range" {
  default = "10.0.1.0/24"
}

variable "zone" {
  default = "correlaid.org"
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

variable "domain" {
  default = "correlaid.org"
}

variable "git_user" {
  default = "correlaid"
}

variable "git_repo" {
  default = "jstet/basel_viz"
}

variable "supabase_db_pw" {
  type = string
}

variable "supabase_project_id" {
  type = string
}

variable "wasabi_access_key"{
  type = string
}

variable "wasabi_secret_key"{
  type = string
}

variable "wasabi_bucket"{
  type = string
}

variable "smtp_user"{
  type = string
  default = "bot@correlaid.org"
}

variable "smtp_password"{
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
  default = "kompetenzdatenbank"
}


variable "directus_key"{
  type = string
}

variable "directus_secret"{
  type = string
}