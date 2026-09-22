FROM php:8.2-apache
RUN docker-php-ext-install pdo_mysql mysqli
COPY src/ /var/www/html/
WORKDIR /var/www/html
EXPOSE 80