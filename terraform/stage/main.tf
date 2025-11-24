terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  service_account_key_file = "packer-key.json"
  folder_id = "b1ga8kilo5nklegmh627"
  zone = "ru-central1-a"
}

# Сеть
resource "yandex_vpc_network" "app-network" {
  name = "reddit-app-network"
}

# Подсеть
resource "yandex_vpc_subnet" "app-subnet" {
  name           = "reddit-app-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.app-network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# ВМ для приложения (используем образ из Packer)
resource "yandex_compute_instance" "app" {
  name        = "reddit-app-stage"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    cores = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd820mf6aljucqk2tcgh"  # Образ из Packer
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.app-subnet.id
    nat = true
  }

  metadata = {
    ssh-keys = "ubuntu:$(cat ~/.ssh/appuser.pub)"
  }
}
