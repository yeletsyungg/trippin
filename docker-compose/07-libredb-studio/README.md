# 07. LibreDB Studio

Развёртывание веб-IDE для работы с базами данных LibreDB Studio через Docker Compose.

## Задание

Источник: [content/Docker/DockerCompose/LibreDB_Studio.md](https://gitflic.ru/project/rurewa/mfua/blob?file=content/Docker/DockerCompose/LibreDB_Studio.md&branch=master)

## Что сделано

- Создан `compose.yaml` с сервисом **libredb-studio**:
  - Образ `ghcr.io/libredb/libredb-studio:latest`
  - Порт `3000:3000`
  - Volume `libredb-data` → `/app/data`
  - Healthcheck через `wget --spider http://localhost:3000`
- Создан `.env` с обязательными переменными: `ADMIN_EMAIL`, `ADMIN_PASSWORD`, `JWT_SECRET`
- Проект запущен: `docker compose up -d`
- Встроенная SQLite-база `sample-employees.db` засеялась автоматически
- Выполнен вход в веб-интерфейс по адресу http://localhost:3000
- Проверена работа SQL-редактора

## Настройка

Скопируйте `.env.example` в `.env`. Задайте собственные пароли и случайный `JWT_SECRET` длиной не менее 32 символов. Файл `.env` хранится только локально.

## Команды

```bash
docker compose ls
ss -tulpn | grep :3000
docker ps -a | grep libredb-studio
docker compose config
docker compose up -d
docker compose ps -a
docker compose logs --tail=20 libredb-studio
docker compose logs -f
docker compose down -v
docker image rm ghcr.io/libredb/libredb-studio:latest
```

## Доступ

- LibreDB Studio: http://localhost:3000
- Логин и пароль: значения `ADMIN_EMAIL` и `ADMIN_PASSWORD` из локального `.env`.

## Файлы проекта

- `compose.yaml` — конфигурация сервиса
- `.env.example` — шаблон переменных окружения; заполненный `.env` не публикуется.

## Скриншоты



### 1. Запуск проекта
![docker compose up](screenshots/02-up.jpg)

### 2. Логи
![Логи](screenshots/03-logs.jpg)

### 3. Страница входа
![Вход](screenshots/04-login.png)

### 4. Главный экран
![Дашборд](screenshots/05-dashboard.png)

### 5. SQL-редактор
![Query Editor](screenshots/06-query.png)
