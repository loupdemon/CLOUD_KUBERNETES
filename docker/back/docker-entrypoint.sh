#!/bin/bash

cp -R /var/www/tmp/. /var/www/html/
chown -R www-data:www-data /var/www/html
sleep 5
cd /var/www/html && php artisan migrate --force
exec "$@"
