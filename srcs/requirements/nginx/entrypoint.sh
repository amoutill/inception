#!/bin/sh

mkdir -p /run/nginx
chown -R nginx:nginx /run/nginx

mkdir -p /run/ssl
cp /run/secrets/ssl_* /run/ssl
chown -R nginx:nginx /run/ssl

echo "Starting Nginx..."
su-exec nginx "$@"
