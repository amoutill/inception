#!/bin/sh

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

MARIADB_ROOT_PASSWORD=$(cat /run/secrets/mariadb_root_password)
MARIADB_WP_ADMIN_PASSWORD=$(cat /run/secrets/mariadb_wp_admin_password)
MARIADB_WP_USER_PASSWORD=$(cat /run/secrets/mariadb_wp_user_password)

if [ ! -d /var/lib/mysql/mysql ]; then
  echo "Initializing MariaDB data directory..."
  mysql_install_db --user=mysql --datadir=/var/lib/mysql

  echo "Starting MariaDB in safe mode for setup..."
  mysqld_safe --skip-networking &
  pid="$!"

  while ! mysqladmin ping --silent; do
    echo "Waiting for MariaDB to be ready...";
    sleep 1;
  done

  echo "Securing MariaDB installation..."
  mysql -u root <<-EOF
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';

    DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost');
    DELETE FROM mysql.user WHERE User='';

    DROP DATABASE IF EXISTS test;
    DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';

    FLUSH PRIVILEGES;
EOF

  echo "Setting up WordPress database and users..."
  mysql -u root -p"${MARIADB_ROOT_PASSWORD}" <<-EOF
    CREATE DATABASE wordpress;

    CREATE USER '${MARIADB_WP_ADMIN}'@'%' IDENTIFIED BY '${MARIADB_WP_ADMIN_PASSWORD}';
    GRANT ALL PRIVILEGES ON wordpress.* TO '${MARIADB_WP_ADMIN}'@'%' WITH GRANT OPTION;

    CREATE USER '${MARIADB_WP_USER}'@'%' IDENTIFIED BY '${MARIADB_WP_USER_PASSWORD}';
    GRANT SELECT, INSERT, UPDATE, DELETE ON wordpress.* TO '${MARIADB_WP_USER}'@'%';

    FLUSH PRIVILEGES;
EOF

  echo "Stopping MariaDB setup instance..."
  mysqladmin -u root -p"${MARIADB_ROOT_PASSWORD}" shutdown
  wait "$pid"
fi

echo "Starting MariaDB..."
su-exec mysql $@
