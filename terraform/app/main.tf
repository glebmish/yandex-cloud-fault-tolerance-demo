locals {
  registry_name = "todo-registry"
}

provider "yandex" {
  endpoint =  "api.cloud.yandex.net:443"
  token =     "${var.yc_token}"
  folder_id = "${var.yc_folder}"
  zone =      "ru-central1-c"
}
