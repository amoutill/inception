#!/bin/sh

mkdir -p /run/nginx
chown -R nginx:nginx /run/nginx

mkdir -p /run/ssl
cp /run/secrets/ssl_* /run/ssl
chown -R nginx:nginx /run/ssl

cat > /etc/nginx/nginx.conf <<EOF
pid /run/nginx/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    server_tokens off;

    ssl_protocols TLSv1.2 TLSv1.3;

    server {
        listen 443 ssl;
        server_name ${SITE_FQDN};

        ssl_certificate /run/ssl/ssl_cert;
        ssl_certificate_key /run/ssl/ssl_key;

        root /var/www/wordpress;
        index index.php index.html index.htm;

        error_page 404 /404.html;
        location = /404.html {
            root /usr/share/nginx/html;
        }

        location / {
            try_files \$uri \$uri/ /index.php?\$args;
        }

        location ~ \.php$ {
            include fastcgi.conf;
            fastcgi_pass ${WORDPRESS_HOST}:9000;
            fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
            include fastcgi_params;
        }

        location ~ /\. {
            deny all;
        }
    }
}
EOF
echo "Starting Nginx..."
su-exec nginx "$@"
