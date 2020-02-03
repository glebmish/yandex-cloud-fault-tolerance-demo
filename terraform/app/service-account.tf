resource "yandex_iam_service_account" "todo_ig_sa" {
  name        = "${var.user}-todo-ig-sa"
  description = "service account to manage IG"
}

resource "yandex_resourcemanager_folder_iam_binding" "folder_editor" {
  folder_id   = "${var.yc_folder}"
  role = "editor"
  members = [
    "serviceAccount:${yandex_iam_service_account.todo_ig_sa.id}",
  ]
  sleep_after = 30
}

resource "yandex_iam_service_account" "todo_node_sa" {
  name        = "${var.user}-todo-node-sa"
  description = "service account to manage docker images on nodes"
}

resource "yandex_resourcemanager_folder_iam_binding" "folder_puller" {
  folder_id   = "${var.yc_folder}"
  role = "container-registry.images.puller"
  members = [
    "serviceAccount:${yandex_iam_service_account.todo_node_sa.id}",
  ]
}
