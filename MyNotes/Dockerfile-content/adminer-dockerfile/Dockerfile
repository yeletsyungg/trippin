FROM php:8.2-cli-alpine

# Установка расширений для PostgreSQL
RUN apk add --no-cache postgresql-dev \
    && docker-php-ext-install pdo_pgsql

# Создание директории для приложения
WORKDIR /app

# Загрузка Adminer
RUN curl -fsSL -o adminer.php https://www.adminer.org/latest.php && chmod +x adminer.php

# Открытие порта
EXPOSE 8080

# Запуск встроенного PHP сервера
CMD ["php", "-S", "0.0.0.0:8080", "-t", "/app"]
