FROM alpine:3.19

RUN apk upgrade --no-cache -a && \
    apk add --no-cache wget tar php-fpm su-exec

RUN addgroup -S php && \
	adduser -S php -G php -G www-data && \
	chown -R php:php /var/log/php82

COPY php-fpm.conf /etc/php82/php-fpm.conf

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["php-fpm82", "-F"]
