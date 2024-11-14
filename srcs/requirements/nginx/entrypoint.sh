#!/bin/sh

mkdir -p /run/nginx
chown -R nginx:nginx /run/nginx

echo "Starting Nginx..."
su-exec nginx "$@"
