FROM alpine:3.19

RUN apk upgrade --no-cache -a && apk add --no-cache mariadb mariadb-client su-exec

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["mysqld","--skip-networking=false", "--port=3306"]
