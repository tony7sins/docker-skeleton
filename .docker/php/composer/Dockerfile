ARG tag

# start with the official Composer image and name it
FROM composer:${tag} AS composer

# Update composer to latest version.
RUN composer self-update --no-interaction --no-progress 