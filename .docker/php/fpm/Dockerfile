ARG PHP_VERSION=7.4.2

# continue with the official PHP image
FROM php:${PHP_VERSION}-fpm AS php

ARG PROJECT_PATH=app
ARG LOCAL_PROJECT_PATH="/usr/src/app"

WORKDIR /tmp
COPY .docker/php/php-ext-installer.sh .

RUN chmod 777 /tmp/php-ext-installer.sh && /tmp/php-ext-installer.sh $PHP_VERSION

RUN apt-get -yqq update && \
    apt-get -yqq install --no-install-recommends \
    # libmcrypt-dev \
    # apt-utils \
    zip \ 
    unzip \
    libzip-dev \
    && docker-php-ext-install zip 

# copy the Composer PHAR from the Composer image into the PHP image
COPY --from=composer /usr/bin/composer /usr/bin/composer

# show that both Composer and PHP run as expected
RUN chmod +x /usr/bin/composer && composer --version && php -v

# Define composer environment variables
ENV \
    #   COMPOSER_HOME=/home/glpi/composer \
    #   PATH=/home/glpi/composer/vendor/bin:$PATH
    COMPOSER_ALLOW_SUPERUSER 1

# COPY app/composer.json app/composer.lock composer/auth.json /tmp/
COPY app/composer.json app/composer.lock /tmp/

RUN composer install \
    --no-interaction \
    --no-plugins \
    --no-scripts \
    --prefer-dist \
    && rm -rf composer.json composer.lock vendor/ 

COPY app/composer.json app/composer.lock ${LOCAL_PROJECT_PATH}/

WORKDIR ${LOCAL_PROJECT_PATH}/
# WORKDIR /usr/src/app/
RUN composer install && chmod +rx public/index.php
# PATH=$PATH:/usr/src/app/bin:/usr/src/app/vendor/bin:bin