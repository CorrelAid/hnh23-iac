terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.39.0"
    }
    hetznerdns = {
      source  = "timohirt/hetznerdns"
      version = "2.2.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }

  }
}
