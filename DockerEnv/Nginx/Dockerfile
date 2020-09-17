FROM nginx:stable-alpine

RUN mkdir -p /var/www/public

COPY appstack/phpapp/public /var/www/public

COPY Nginx/conf/phpapp.conf /etc/nginx/conf.d/phpapp.conf
COPY Nginx/conf/nodejsapp.conf /etc/nginx/conf.d/nodejsapp.conf
