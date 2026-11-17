# 08. HomeHub

Развёртывание семейной панели управления HomeHub из upstream-репозитория.

## Задание

Источник: [content/Docker/DockerCompose/Homehub.md](https://gitflic.ru/project/rurewa/mfua/blob?file=content/Docker/DockerCompose/Homehub.md&branch=master)
Upstream: [github.com/surajverma/homehub](https://github.com/surajverma/homehub)

## Что сделано

- Клонирован репозиторий HomeHub: `git clone https://github.com/surajverma/homehub.git`
- Создан `config.yml` — конфигурация с настройками интерфейса, списком членов семьи, категориями напоминаний, темой
- Заменён `compose.yml` — сервис **homehub** с портом `5000:5000` и bind-mount для `config.yml` и папок `uploads/media/pdfs/data`
- Проект запущен: `docker compose up -d`
- Открыт веб-интерфейс по адресу http://localhost:5000
- Проверена работа одной из функций (плитки)

## Команды

```bash
cd ~
git clone https://github.com/surajverma/homehub.git
cd homehub
touch config.yml
docker compose up -d
docker compose ps
docker compose logs -f
docker compose down -v
docker compose down --rmi all -v
```

## Доступ

- HomeHub UI: http://localhost:5000
- Пароль: пустой (password-less режим)

## Скриншоты


### 1. Запуск проекта
![docker compose up](screenshots/01-up.jpg)

### 2. Логи
![Логи](screenshots/02-logs.jpg)

### 3. Дашборд HomeHub
![Дашборд](screenshots/03-dashboard.png)

### 4. Функция в работе
![Функция](screenshots/04-feature.png)