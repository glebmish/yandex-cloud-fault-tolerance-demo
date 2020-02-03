output "tank_instance_id" {
  value = "${yandex_compute_instance.tank.id}"
}

output "tank_address" {
  value = "${yandex_compute_instance.tank.network_interface.0.nat_ip_address}"
}
