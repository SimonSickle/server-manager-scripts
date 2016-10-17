#!/bin/bash

ip="104.167.7.52"

if [ "$1" = "patrickc" ]; then
ip="104.167.7.50"
fi

if [ "$1" = "bens" ]; then
ip="104.167.7.51"
fi

mkdir -p "/etc/nginx/user-configs/$1"
phpsocket="/var/run/php-$1"

rm -rf "/etc/nginx/user-configs/$1/"
mkdir -p "/etc/nginx/user-configs/$1"

if [ -d "/home/$1/extra-configs/nginx/" ]; then
    cd "/home/$1/extra-configs/nginx/"
    for i in $(ls *.conf); do
        echo "extra config: $i"
        cp "$i" "/etc/nginx/user-configs/$1/"
    done
fi

cd "/home/$1/www/"
for i in $( ls ); do
    rootdir="$(pwd)/$i"
    echo "Creating site $i on nginx"
    if [ ! -f "/etc/nginx/user-configs/$1/$i.conf" ]; then
        sed -e "s/URL/$i/g" -e "s/IP_ADDR/$ip/" -e "s#PHP_SOCKET#$phpsocket#" -e "s#ROOT_DIR#$rootdir#" /mnt/hdd-store/nginx.template > "/etc/nginx/user-configs/$1/$i.conf"
    fi
done

sleep 3
/bin/systemctl restart nginx

for i in $( ls ); do
    rootdir="$(pwd)/$i"

    cd ../
    echo "Making a SSL cert"
    setup-ssl-certbot.sh $i $rootdir
    cd www/

    if [ -d "/etc/letsencrypt/live/$i/" ]; then
        rm "/etc/nginx/user-configs/$1/$i.conf"
        sed -e "s/URL/$i/g" -e "s/IP_ADDR/$ip/" -e "s#PHP_SOCKET#$phpsocket#" -e "s#ROOT_DIR#$rootdir#" /mnt/hdd-store/nginx-ssl.template > "/etc/nginx/user-configs/$1/$i.conf"
    fi
done
