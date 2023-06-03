terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
    hetznerdns = {
      source  = "timohirt/hetznerdns"
      version = "2.2.0"
    }
    

  }
}


provider "hcloud" {

}

provider "hetznerdns" {
}


