#!/usr/bin/env bash

APP_DIR=app

function createApp() {
    if [[ -d $APP_DIR ]]; then
        echo -n "Deleting $APP_DIR!"
        sleep 0.5 && echo -n '.'
        sleep 0.5 && echo -n '.'
        sleep 0.5 && echo '.'
        rm -rf "${APP_DIR:-app}/"
    else
        echo 'Initialiated new project dir'
    fi

    case $1 in
    symfony)
        echo "Project will be installed via $1?"
        symfony new app --full
        ;;
    composer)
        echo "Project will be installed via $1?"
        composer create-project symfony/website-skeleton app
        ;;
    esac

    # cd $APP_DIR && composer install
    echo -n "Creating ${APP_DIR:-app}/.env.local"
    sleep 0.5 && echo -n '.'
    sleep 0.5 && echo -n '.'
    sleep 0.5 && echo '.'
    sed -e '/^DATABASE_URL/s/^/# /' "${APP_DIR:-app}/".env | tee "${APP_DIR:-app}/".env.local

    echo -n "Deleting ${APP_DIR:-app}/.env"
    sleep 0.5 && echo -n '.'
    sleep 0.5 && echo -n '.'
    sleep 0.5 && echo '.'
    mv "${APP_DIR:-app}/".env "${APP_DIR:-app}/".env.example
}

if [[ $(which symfony) && -f $(which composer) ]]; then
    createApp symfony
elif which composer; then
    createApp composer
else
    echo 'install composer or/and symfony loaclly!'
fi
