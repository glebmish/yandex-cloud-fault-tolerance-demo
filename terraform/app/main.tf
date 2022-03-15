locals {
  registry_name = "todo-registry"
}

terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  endpoint =  "api.cloud.yandex.net:443"
  token =     "${var.yc_token}"
  folder_id = "${var.yc_folder}"
  zone =      "ru-central1-c"
}
