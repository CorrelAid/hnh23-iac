
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

variable "volume_size" {
  type        = number
  description = "Volume size (GB) (min 10, max 10240)"
  default     = 10 # https://docs.hetzner.cloud/#volumes-create-a-volume
  validation {
    condition     = ceil(var.volume_size) == var.volume_size
    error_message = "Volume size must be a whole number between 10 and 10240."
  }
  validation {
    condition     = var.volume_size >= 10
    error_message = "Volume size value too small. The minimum volume size is 10 (10GB)."
  }
  validation {
    condition     = var.volume_size <= 10240
    error_message = "Volume size value too large. The maximum volume size is 10240 (10TB)."
  }
}

variable "volume_filesystem" {
  type        = string
  description = "Volume filesystem"
  default     = "xfs" # https://docs.hetzner.cloud/#volumes-create-a-volume
  validation {
    condition     = length(regexall("^ext4|xfs$", var.volume_filesystem)) > 0
    error_message = "Invalid volume filesystem type value. Valid filesystem types are ext4 or xfs."
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


