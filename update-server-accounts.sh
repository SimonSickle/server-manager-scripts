#!/bin/bash

cd /home/
rm -rf /etc/nginx/user-configs/*
rm -rf /etc/php5/fpm/users.d/*

for i in $( ls ); do
	create_phpfpm.sh $i
	nginx-setup.sh $i
done

fixowner.sh

/bin/systemctl restart php5-fpm
/bin/systemctl restart nginx
