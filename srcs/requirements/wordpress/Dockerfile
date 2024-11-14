FROM alpine:3.19

RUN apk upgrade --no-cache -a && \
    apk add --no-cache wget tar php-fpm

RUN addgroup -S php && \
	adduser -S php -G php -G www-data && \
	chown -R php:php /var/log/php82

WORKDIR /usr/share/webapps

RUN wget https://wordpress.org/latest.tar.gz && \
	tar -xzvf latest.tar.gz && \
	rm latest.tar.gz && \
	chown -R php:www-data .

RUN apk del --no-cache --purge wget tar

USER php
ENTRYPOINT ["php-fpm82", "-F"]
