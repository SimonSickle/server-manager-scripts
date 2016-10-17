#!/bin/bash
password=$(date +%s | sha256sum | base64 | head -c 32)

useradd -m "$1" -s /bin/bash -p "$password"
chage -d0 "$1"

# Make directory for storage
mkdir -p "/mnt/hdd-store/home/$1"
chown -R "/mnt/hdd-store/home/$1"
ln -s "/mnt/hdd-store/home/$1" "/home/$1"

# Create PHP
create_phpfpm.sh "$1" "$2"

# Update nginx
nginx-setup.sh "$1" "$2"

echo "User created: $1"
echo "PHP Info:"
echo "Socket: /var/run/php-$2.sock"
