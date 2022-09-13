# Terraform-спецификация окружения для TodoList

## Деплой приложения
1. Установить terraform: `https://www.terraform.io`
1. Перейти в директорию со спецификацией окружения:
    ```bash
    cd app
    ```
1. Инициализировать terraform в директории со спецификацией:
    ```bash
    terraform init
    ```
1. Если реестр, в котором лежат docker-образы приложения, называется не `todo-registry`, измените переменную `registry_name` 
в файле [main.tf](app/main.tf). 
1. Развернуть и запустить приложение. 
    * folder_id - каталог, в котором будет развернуто приложение,
    * yc_token - OAuth токен пользователя, от имени которого будет развернуто приложение
    ```bash
    terraform apply -var yc_folder=<folder_id> -var yc_token=<yc_token> -var user=$USER
    ```
1. Для доступа к приложению нужно перейти по адресу `lb_address`, полученному в результате выполнения `terraform apply`.

## Создаваемые ресурсы
* VPC Network с тремя подсетями во всех зонах доступности;
* 2 Сервисных аккаунта:
    * Сервисный аккаунт для управления группой ВМ с ролью `editor`;
    * Сервисный аккаунт для скачивания docker-образа на ВМ с ролью `container-registry.images.puller`;
* Группа ВМ с 4 инстансами на базе Container Optimized Image в зонах доступности `ru-central1-b` и `ru-central1-c`;
* Кластер Managed PostgreSQL с двумя хостами в зонах доступности `ru-central1-b` и `ru-central1-c`;
* Балансировщик нагрузки, распределяющий трафик по инстансам группы ВМ.

## Удаление приложения
**Внимание: если создана ВМ с Танком, необходимо сначала удалить ее, иначе удаление VPC завершится с ошибкой.**
```bash
terraform destroy -var yc_folder=<folder_id> -var yc_token=<yc_token> -var user=$USER
```

## Деплой и запуск Yandex Tank
1. Установить terraform: `https://www.terraform.io`
1. Перейти в директорию со спецификацией Танка:
    ```bash
    cd tank
    ```
1. Инициализировать terraform в директории со спецификацией Танка:
    ```bash
    terraform init
    ```
1. В файле [tank/main.tf](tank/main.tf) укажите путь к публичному и приватному ssh ключам (Дефолтные значения `~/.ssh/id_ed25519.pub` и `~/.ssh/id_ed25519`)
1. Развернуть и запустить приложение. 
    
    **Внимание: Танк необходимо создавать после основного окружения, так как оно необходимо для генерации конфигов.**
    * folder_id - каталог, в котором будет развернут Танк,
    * yc_token - OAuth токен пользователя, от имени которого будет развернут Танк
    * overload_token - токен для подключения к https://overload.yandex.net. Для получения токена надо аутентифицироваться, 
    после чего нажать справа вверху на свой профиль и в выпадающем меню выбрать "My api token"
    ```bash
    terraform apply -var yc_folder=<folder_id> -var yc_token=<yc_token> -var user=$USER -var overload_token=<overload_token>
    ```
1. Зайти на созданную ВМ по ssh. Адрес можно посмотреть в выводе команды `terraform apply` выше.
1. Запустить Танк
    ```bash
    sudo yandex-tank -c load.yaml
    ```
1. Перейти в `https://overload.yandex.net` и найти там запущенную стрельбу (public tests -> show my tests only)

## Удаление Танка
```bash
terraform destroy -var yc_folder=<folder_id> -var yc_token=<yc_token> -var user=$USER -var overload_token=not-used
```
