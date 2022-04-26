data "yandex_compute_image" "tank_image" {
  family = "yandextank"
}

data "yandex_vpc_network" "todo-network" {
  name = "todo-network"
}

data "yandex_vpc_subnet" "todo-subnet-a" {
  name = "todo-subnet-a"
}

data "yandex_lb_network_load_balancer" "todo_lb" {
  name = "todo-lb"
}

resource "yandex_compute_instance" "tank" {
  name        = "todo-tank"
  folder_id   = var.yc_folder
  zone        = "ru-central1-a"
  platform_id = "standard-v2"
  resources {
    memory = 2
    cores  = 2
  }
  boot_disk {
    mode = "READ_WRITE"
    initialize_params {
      image_id = data.yandex_compute_image.tank_image.id
      size     = 10
    }
  }
  network_interface {
    subnet_id = data.yandex_vpc_subnet.todo-subnet-a.id
    nat       = "true"
  }
  metadata = {
    user-data = templatefile("${path.module}/files/user-data.tpl", {
      user    = var.user
      ssh-key = "${local.public_ssh_key}"
    })
  }

  // below are files that will be used by tank

  provisioner "file" {
    content = templatefile("${path.module}/files/load.yaml.tpl", {
      address = "${tolist(tolist(data.yandex_lb_network_load_balancer.todo_lb.listener).0.external_address_spec).0.address}"
      port    = "${tolist(data.yandex_lb_network_load_balancer.todo_lb.listener).0.port}"
    })
    destination = "/home/${var.user}/load.yaml"
    connection {
      type        = "ssh"
      user        = var.user
      private_key = local.private_ssh_key
      host        = yandex_compute_instance.tank.network_interface.0.nat_ip_address
    }
  }

  provisioner "file" {
    source      = "files/ammo_add.txt"
    destination = "/home/${var.user}/ammo_add.txt"
    connection {
      type        = "ssh"
      user        = var.user
      private_key = local.private_ssh_key
      host        = yandex_compute_instance.tank.network_interface.0.nat_ip_address
    }
  }

  provisioner "file" {
    source      = "files/ammo_list.txt"
    destination = "/home/${var.user}/ammo_list.txt"
    connection {
      type        = "ssh"
      user        = var.user
      private_key = local.private_ssh_key
      host        = yandex_compute_instance.tank.network_interface.0.nat_ip_address
    }
  }

  provisioner "file" {
    source      = "files/monitoring.xml"
    destination = "/home/${var.user}/monitoring.xml"
    connection {
      type        = "ssh"
      user        = var.user
      private_key = local.private_ssh_key
      host        = yandex_compute_instance.tank.network_interface.0.nat_ip_address
    }
  }

  provisioner "file" {
    content     = var.overload_token
    destination = "/home/${var.user}/token.txt"
    connection {
      type        = "ssh"
      user        = var.user
      private_key = local.private_ssh_key
      host        = yandex_compute_instance.tank.network_interface.0.nat_ip_address
    }
  }
}
