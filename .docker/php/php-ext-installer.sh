#!/usr/bin/env bash

PHP_VERSION=$1
# Clean APT sources list to prevent packages list update error:
# E: Could not open file /var/lib/apt/lists/deb.debian.org_debian_dists_buster_main_binary-amd64_Packages.diff_Index - open (2: No such file or directory)
rm -rf /var/lib/apt/lists/*
# Update APT sources list
apt-get update
# Install MySQL client.
apt-get install --assume-yes --no-install-recommends --quiet default-mysql-client

# Install mail server and getmail utility.
# && apt-get install --assume-yes --no-install-recommends --quiet dovecot-imapd dovecot-pop3d getmail4 \
# && maildirmake.dovecot /home/circleci/Maildir circleci \

# Install Opcache.
apt-get install --assume-yes --no-install-recommends --quiet \
    gcc \
    make \
    autoconf \
    libc-dev \
    pkg-config \
    build-essential \
    apt-utils \
    vim
# libpq
docker-php-ext-install opcache bcmath sockets

# Install exif extension.
docker-php-ext-install exif

# Install GD PHP extension.
# GD extension configuration parameters changed on PHP 7.4
# see https://www.php.net/manual/en/image.installation.php#image.installation
apt-get install --assume-yes --no-install-recommends --quiet libfreetype6-dev libjpeg-dev libpng-dev

PHP_MAJOR_VERSION="$(echo "$PHP_VERSION" | cut -d '.' -f 1)"
PHP_MINOR_VERSION="$(echo "$PHP_VERSION" | cut -d '.' -f 2)"

if [ "$PHP_MAJOR_VERSION" -le "5" ] || ([ "$PHP_MAJOR_VERSION" -eq "7" ] && [ "$PHP_MINOR_VERSION" -le "3" ]); then
    # For PHP <= 5.x or PHP 7 <= 7.3, use old parameters
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
else

    docker-php-ext-configure gd --with-freetype --with-jpeg
fi
docker-php-ext-install gd

# Install mysqli PHP extension (required only for GLPI prior to 10.0).
docker-php-ext-install mysqli

# Install PDO MySQL PHP extension.
docker-php-ext-install pdo pdo_mysql

# Install XMLRPC PHP extension.
apt-get install --assume-yes --no-install-recommends --quiet libxml2-dev
docker-php-ext-install xmlrpc

# Install the "intl" PHP extension for best performance.
apt-get install -y libicu-dev
docker-php-ext-configure intl
docker-php-ext-install intl

# Install AMQP PHP extension.
apt-get install --assume-yes --no-install-recommends --quiet \
    librabbitmq-dev libssh-dev
pecl install amqp
# echo "extension=amqp.so" >>/usr/local/etc/php/conf.d/docker-php-ext-amqp.ini
docker-php-ext-enable amqp

# Install APCU PHP extension.
# apcu-4.0.11 is the fallback version for PHP prior to 7.0
(pecl install apcu || pecl install apcu-4.0.11)
docker-php-ext-enable apcu
echo "apc.enable=1" >>/usr/local/etc/php/conf.d/docker-php-ext-apcu.ini
echo "apc.enable_cli=1" >>/usr/local/etc/php/conf.d/docker-php-ext-apcu.ini

# Update PHP configuration.
echo "memory_limit = 512M" >>/usr/local/etc/php/conf.d/docker-php-memory.ini

# Disable xdebug PHP extension.
# && rm /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \

# Clean sources list.
rm -rf /var/lib/apt/lists/*
rm -Rf /tmp/*
