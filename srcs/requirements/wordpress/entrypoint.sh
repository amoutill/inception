#!/bin/sh

if [ ! -d /var/www/wordpress ]; then
  echo "Wordpress not found, installing..."
  mkdir -p /var/www
  cd /var/www
  echo "Downloading Wordpress archive..."
  wget -q https://wordpress.org/latest.tar.gz
  echo "Extracting Wordpress archive..."
  tar -xzf latest.tar.gz
  rm latest.tar.gz
  chown -R php:www-data .
  echo "Wordpress installed successfully!"
fi

echo "Starting PHP-FPM..."
su-exec php "$@"
