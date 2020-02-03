resource "yandex_lb_network_load_balancer" "todo_lb" {
  name = "todo-lb"

  listener {
    name = "todo-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = "${yandex_compute_instance_group.todo_instances.load_balancer.0.target_group_id}"

    healthcheck {
      name = "todo-http-hc"
      http_options {
        port = 80
        path = "/alive"
      }
    }
  }
}
