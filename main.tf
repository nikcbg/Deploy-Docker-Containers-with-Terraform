# Declare the Docker provider
terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

# Specifying the Docker provider configuration, in this case I am using local host 
provider "docker" {

 host = "tcp://localhost:2375" # The localhost:2375 is the default address for the Docker daemon.
 # host = "unix:///var/run/docker.sock" - defaults to a Linux machine with Docker installed
 # host = "npipe:////.//pipe//docker_engine" - defaults to a Windows machine with Docker installed
 
}

# Creating a Docker Ubuntu Image with the latest tag.
resource "docker_image" "ubuntu" {
  name = "ubuntu:precise"
}

# Creating a Docker Container using the latest ubuntu image.
resource "docker_container" "webserver" {
  image             = docker_image.ubuntu.image_id
  name              = "ubuntut"
  must_run          = true
  publish_all_ports = true
  command = [
    "tail",
    "-f",
    "/dev/null"
  ]
}

# Creating a nginx Image with the latest tag
resource "docker_image" "nginx" {               
  name = "nginx:latest"
}

# Creating a Docker Container using the latest nginx image
resource "docker_container" "nginxr" {   
  name = "nginx"  
  image = docker_image.nginx.image_id   
  ports {
    internal = 80
    external = 8000
  }
}
