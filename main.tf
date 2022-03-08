terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.68.0"
    }
  }
}

provider "yandex" {
  service_account_key_file = "./keys/yandex/key.json"
  cloud_id                 = "b1gm927ukaa70tqajugl"
  folder_id                = "b1gc6voj6kklco2mpnnn"
  zone                     = "ru-central1-a"
}

resource "yandex_compute_instance" "vm1" {
  name = "vm1"
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      # ubuntu 20-04
      image_id = "fd83n3uou8m03iq9gavu"
      size     = 20
    }
  }


  network_interface {
    subnet_id = "e9bp42kcejc94uaga548"
    nat       = true
  }

  metadata = {
    ssh-keys = "cableman:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "vm2" {
  name = "vm2"
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      # ubuntu 20-04
      image_id = "fd83n3uou8m03iq9gavu"
      size     = 20
    }
  }


  network_interface {
    subnet_id = "e9bp42kcejc94uaga548"
    nat       = true
  }

  metadata = {
    ssh-keys = "cableman:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "vm3" {
  name = "vm3"
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      # CentOS 7 
      image_id = "fd82n2d2h9fet9648lej"
      size     = 20
    }
  }


  network_interface {
    subnet_id = "e9bp42kcejc94uaga548"
    nat       = true
  }

  metadata = {
    ssh-keys = "cableman:${file("~/.ssh/id_rsa.pub")}"
  }
}

data "template_file" "inventory" {
  template = file("./terraform/_templates/inventory.tpl")

  vars = {
    user1 = "ubuntu"
    user2 = "centos" 
    host1 = join("", [yandex_compute_instance.vm1.network_interface[0].nat_ip_address])
    host2 = join("", [yandex_compute_instance.vm2.network_interface[0].nat_ip_address])
    host3 = join("", [yandex_compute_instance.vm3.network_interface[0].nat_ip_address])
  }
}

resource "local_file" "save_inventory" {
  content  = data.template_file.inventory.rendered
  filename = "./ansible/inventory"
}
