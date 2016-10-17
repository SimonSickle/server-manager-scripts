#!/bin/bash
sed -e "s/USER_SHORT/$1/g" -e "s/USER_LONG/$1/" /mnt/hdd-store/php-fpm.template > "/etc/php5/fpm/users.d/$1.conf"
echo "Socket /var/run/php-$1.sock"
