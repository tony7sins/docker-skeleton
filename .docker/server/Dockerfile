FROM nginx:stable

COPY .docker/server/conf.add/ /etc/nginx/conf.add

# RUN mkdir -p /tmp/nginx_cache && chmod -R +rw /tmp/nginx_cache

RUN nginx -V