#!/bin/bash
for i in $( ls ); do
	echo "Fixing ownership of $i"
	chown -R "$i":"$i" "$i"/
	echo "Fixing directory perms"
	find "$i"/ -type d -print0 | xargs -0 chmod 755
	echo "Fixing file perms"
	find "$i"/ -type f -print0 | xargs -0 chmod 644
	chmod 755 "$i"
	echo "----------------------"
done
