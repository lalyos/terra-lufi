variable "port" {
  description = "Port to expose"
  default = 8080
}

variable "tag" {
  description = "Version of the image to use"
  default = "latest"
}

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  } 
}

resource "docker_image" "nginx" {
  name         = "nginx:${var.tag}"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "tutorial"

  ports {
    internal = 80
    external = var.port
  }
}

output "port" {
  value = "${docker_container.nginx.ports[0].external}"
}

output "url" {
  value = "http://127.0.0.1:${docker_container.nginx.ports[0].external}"
}
