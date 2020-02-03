resource "yandex_vpc_network" "todo-network" {
  name = "todo-network"
}

resource "yandex_vpc_subnet" "todo-subnet-a" {
  name = "todo-subnet-a"
  v4_cidr_blocks = ["10.2.0.0/16"]
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.todo-network.id}"
}

resource "yandex_vpc_subnet" "todo-subnet-b" {
  name = "todo-subnet-b"
  v4_cidr_blocks = ["10.3.0.0/16"]
  zone           = "ru-central1-b"
  network_id     = "${yandex_vpc_network.todo-network.id}"
}

resource "yandex_vpc_subnet" "todo-subnet-c" {
  name = "todo-subnet-c"
  v4_cidr_blocks = ["10.4.0.0/16"]
  zone           = "ru-central1-c"
  network_id     = "${yandex_vpc_network.todo-network.id}"
}
