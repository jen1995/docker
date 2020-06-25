# docker

Как собрать докер-образ

1. Перекинуть на сервер папку docker с рабочего стола
2. Перейти в папку docker, запустить команду docker build -t eelistr .
-t — тэг, название образа в docker images
. — где искать докер-файл (. = в текущей папке) В докерфайле вручную вбит публичный ключ и user-id (узнать user-id: id -u , запускать на зомбике вне докера)
2. Запустить в папке docker
DOCKER_JUPYTER_PORT=9016 DOCKER_TENSORBOARD_PORT=9017 DOCKER_SSH_PORT=9023 WORKINGDIR=/mnt/meteo-storage/eelistr ./run_docker_notebooks.sh

Очистить кэш от собранных докер-образов
docker system prune

Посмотреть собранные докер-образы
docker images

Остановить докер
docker stop <NAME> (например, nifty_ride)
  
Запустить докер с шеллом
docker exec -it <NAME or ID> bash
  
Подключиться в новый докер по SSH
ssh user@zomb-neurocast.weather.yandex.net -p 9023
ssh zomb_new (после добавления строчек, аналогичных zomb1, в ~/.ssh/config)

Чтобы конда начала работать с фишом
source /opt/conda/etc/fish/conf.d/conda.fish

Окружение с tf 1.14
conda activate deeplearning
