#!/bin/sh

if [ ! -d /var/www/wordpress ]; then
  echo "Wordpress not found, installing..."
  mkdir -p /var/www
  cd /var/www
  echo "Downloading Wordpress archive..."
  curl -s -o latest.tar.gz https://wordpress.org/latest.tar.gz
  echo "Extracting Wordpress archive..."
  tar -xzf latest.tar.gz
  rm latest.tar.gz
  echo "Preparing config file..."
  cd wordpress
  MARIADB_WP_USER_PASSWORD=$(cat /run/secrets/mariadb_wp_user_password)
  cat > wp-config.php <<-EOF
<?php

/** The name of the database for WordPress */
define( 'DB_NAME', '${MARIADB_WP_DB}' );

/** Database username */
define( 'DB_USER', '${MARIADB_WP_USER}' );

/** Database password */
define( 'DB_PASSWORD', '${MARIADB_WP_USER_PASSWORD}' );

/** Database hostname */
define( 'DB_HOST', '${MARIADB_HOST}' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

EOF
  curl -s >> wp-config.php https://api.wordpress.org/secret-key/1.1/salt/
  cat >> wp-config.php <<-EOF

\$table_prefix = 'wp_';

define( 'WP_DEBUG', false );

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
EOF

  echo "Setting owner..."
  chown -R php:www-data .
  echo "Wordpress installed successfully!"
fi

echo "Starting PHP-FPM..."
su-exec php "$@"
