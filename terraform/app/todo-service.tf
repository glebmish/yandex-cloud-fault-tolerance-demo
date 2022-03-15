data "yandex_compute_image" "coi" {
  family = "container-optimized-image"
}

data "yandex_container_registry" "todo_registry" {
  name = "${local.registry_name}"
  folder_id = "${var.yc_folder}"
}

resource "yandex_compute_instance_group" "todo_instances" {
  name = "todo-ig"
  folder_id = "${var.yc_folder}"
  service_account_id = "${yandex_iam_service_account.todo_ig_sa.id}"
  instance_template {
    platform_id = "standard-v2"
    resources {
      memory = 2
      cores = 2
    }
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "${data.yandex_compute_image.coi.id}"
        size = 30
      }
    }
    network_interface {
      network_id = "${yandex_vpc_network.todo-network.id}"
      nat = "true"
    }
    service_account_id = "${yandex_iam_service_account.todo_node_sa.id}"
    metadata = {
      ssh-keys = "${var.user}:${file("~/.ssh/id_rsa.pub")}"
      docker-container-declaration = templatefile(
        "${path.module}/files/spec.yaml",
        {
          docker_image = "cr.yandex/${data.yandex_container_registry.todo_registry.id}/todo-demo:v1"
          database_uri = "postgresql://${local.dbuser}:${local.dbpassword}@:1/${local.dbname}"
          database_hosts = "${join(",", local.dbhosts)}"
        }
      )
    }
  }

  scale_policy {
    fixed_scale {
      size = 4
    }
  }

  allocation_policy {
    zones = [
      "ru-central1-b",
      "ru-central1-c"
    ]
  }

  deploy_policy {
    max_unavailable = 2
    max_expansion = 2
  }

  load_balancer {
    target_group_name = "tg-ig"
  }

  health_check {
    healthy_threshold = 2
    interval = 2
    timeout = 1
    unhealthy_threshold = 2

    http_options {
      path = "/healthy"
      port = "80"
    }
  }

  depends_on = [
    yandex_resourcemanager_folder_iam_binding.folder_editor
  ]
}
