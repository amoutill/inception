FROM alpine:3.19

RUN apk upgrade --no-cache -a && \
    apk add --no-cache wget tar php82-fpm php82-mysqli php82-curl php82-dom \
		php82-exif php82-fileinfo php82-pecl-imagick php82-mbstring php82-zip \
		php82-gd php82-iconv php82-intl su-exec

RUN addgroup -S php && \
	adduser -S php -G php -G www-data && \
	chown -R php:php /var/log/php82

COPY php-fpm.conf /etc/php82/php-fpm.conf

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["php-fpm82", "-F"]
