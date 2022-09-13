locals {
  public_ssh_key = "${file("~/.ssh/id_ed25519.pub")}"
  private_ssh_key = "${file("~/.ssh/id_ed25519")}"
}

provider "yandex" {
  endpoint  = "api.cloud.yandex.net:443"
  token     = var.yc_token
  folder_id = var.yc_folder
  zone      = "ru-central1-c"
}
