terraform {
  required_version = ">= 0.13"

  required_providers {
    aws    = ">= 3.19"
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 2.8.0"
    }
  }
}