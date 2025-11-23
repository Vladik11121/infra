terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  service_account_key_file = "packer-key.json"
  folder_id                = "b1ga8kilo5nklegmh627"
  zone                     = "ru-central1-a"
}

resource "yandex_compute_instance" "base-image-vm" {
  name        = "base-image-vm"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd84tafb5rjruk3t9vrt"  # Ubuntu 16.04 LTS
      size     = 10
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id = "e9b7db9ld9jg5o5nsj5e"
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQO3pLJa6LELZt+zbOLtkF+3hPZb9+Zzw/rq/54W5uN77CYa56umZCtLZyle6B2GjZutHnHzxzv5DyuXzRzq4ldtwozc5oLW2Mjiwj6iQgjX6hn4BFgDRMoFlD7M4ByydCC3teTkZYXrdgAJdPQtzHu/mU0t6UrsizcHmk3//DlX80q7fdmd/qApK4UAocbsdbHG7zzdJhpBUhb8Ol6e7yKWZ8zN+gifPLEs3jkTIT7+YsZF4S+kdQ1xVCn4vqvxrmhcWP9XHdoaDezPd0Etw5nneJXw1mDuWZy5o1/a5JmfQqISUfEJwL0Q/4PMHmHVYjFkVa3uDJek8p7ABMfbIIypRVIa7bJmlWBJ92yvo0rCkaC44KyDV+JrRLf+2LeclRZ67drAJh9DJ3z5/R6EfI2ztIN6gSNixa8kCtwj4eWT0c1nTPXjhnuCPesbs/iyG3H4xeAVmgUsm3Y7wyneHBcNZDxsxRZuL8qZ7pYcxm+IvP0d6L1okhlNgDkwOAwes= appuser"
  }
}

resource "yandex_compute_image" "reddit-base" {
  name        = "reddit-base-${formatdate("YYYYMMDD-hhmmss", timestamp())}"
  family      = "reddit-base"
  description = "Ubuntu 16.04 with Ruby 2.4.1 and MongoDB"
  source_disk = yandex_compute_instance.base-image-vm.boot_disk.0.disk_id

  timeouts {
    create = "1h"
    delete = "1h"
  }

  depends_on = [yandex_compute_instance.base-image-vm]
}

output "image_id" {
  value = yandex_compute_image.reddit-base.id
}

output "image_name" {
  value = yandex_compute_image.reddit-base.name
}
