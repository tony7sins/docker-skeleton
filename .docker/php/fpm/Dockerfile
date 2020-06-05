ARG PHP_VERSION=7.4.2

# continue with the official PHP image
FROM php:${PHP_VERSION} AS php

ARG PROJECT_PATH=app
ARG LOCAL_PROJECT_PATH="/usr/src/app"

WORKDIR /tmp
COPY .docker/php/php-ext-installer.sh .

RUN chmod 777 /tmp/php-ext-installer.sh && /tmp/php-ext-installer.sh $PHP_VERSION

# allow run Composer as root
ENV COMPOSER_ALLOW_SUPERUSER 1

# copy the Composer PHAR from the Composer image into the PHP image
COPY --from=composer /usr/bin/composer /usr/bin/composer

WORKDIR ${LOCAL_PROJECT_PATH}

# show that both Composer and PHP run as expected
RUN composer --version && php -v