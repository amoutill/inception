FROM alpine:3.19

RUN apk upgrade -a --no-cache

RUN apk add --no-cache mariadb mariadb-client

RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

RUN --mount=type=secret,id=mariadb_root_password,env=MARIADB_ROOT_PASSWORD \
    mysqld_safe --skip-networking & \
    while ! mysqladmin ping --silent; do \
        echo "Waiting for MariaDB to be ready..."; \
        sleep 1; \
    done && \
    mysql -u root -e "\
        SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${MARIADB_ROOT_PASSWORD}'); \
        DELETE FROM mysql.user WHERE User=''; \
        DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost'); \
        DROP DATABASE IF EXISTS test; \
        DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'; \
        FLUSH PRIVILEGES;"

EXPOSE 3306

CMD ["mysqld_safe"]
