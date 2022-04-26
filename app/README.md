# TodoList — демо-приложение для вебинара

Как подготовить приложение для запуска в Яндекс.Облаке:
1. Аутентифицироваться в Container Registry
    ```bash
    yc container registry configure-docker
    ```
1. Создать Container Registry
    ```bash
    yc container registry create --name todo-registry
    ```
1. Собрать docker-образ с тегом v1
    ```bash
    docker build . --tag cr.yandex/<registry_id>/todo-demo:v1 --platform linux/amd64
    ```
1. Собрать docker-образ с тегом v2 (для проверки сценария обновления приложения)
    ```bash
    docker build . --build-arg COLOR_SCHEME=dark --tag cr.yandex/<registry_id>/todo-demo:v2 --platform linux/amd64
    ```
1. Загрузить docker-образы в Container Registry
    ```bash
    docker push cr.yandex/<registry_id>/todo-demo:v1
    docker push cr.yandex/<registry_id>/todo-demo:v2
    ```
