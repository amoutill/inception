#!/bin/sh

if [ ! -d /var/www/wordpress ]; then
  echo "Wordpress not found, installing..."
  mkdir -p /var/www
  cd /var/www
  echo "Downloading wordpress..."
  wp core download --path=wordpress
  echo "Creating config file..."
  cd wordpress
  wp config create \
	 --dbname="${MARIADB_WP_DB}" \
	 --dbuser="${MARIADB_WP_USER}" \
	 --dbpass="$(cat /run/secrets/mariadb_wp_user_password)" \
	 --dbhost="${MARIADB_HOST}" \
	 --skip-check
  echo "Setting owner..."
  chown -R php:www-data .
  echo "Installing wordpress..."
  wp core install \
	 --url="https://${SITE_FQDN}" \
	 --title="${WP_TITLE}" \
	 --admin_user="${WP_ADMIN_USER}" \
	 --admin_password="$(cat /run/secrets/wp_admin_password)" \
	 --admin_email="${WP_ADMIN_EMAIL}"
  echo "Wordpress installed successfully!"
fi

echo "Starting PHP-FPM..."
su-exec php "$@"
