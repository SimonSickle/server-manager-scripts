#!/bin/bash

# 1st argument is domain
# 2nd argument is the webroot

echo "Creating SSL for $1 at $2"
#if [ ! -d "/etc/letsencrypt/live/$i" ]; then
    certbot certonly --webroot -w $2 -d $1 -d www.$1
#fi
