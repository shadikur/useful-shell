#!/bin/bash

OLDIPV4='' # enter here
NEWIPV4=$(curl ipinfo.io/ip)

grep -rl "$OLDIPV4" /etc | xargs sed -i "s#$OLDIPV4#$NEWIPV4#g"
find /home/*/conf/ -type f -exec sed -i "s#$OLDIPV4#$NEWIPV4#g" {} \;
mv /usr/local/vesta/data/ips/$OLDIPV4 /usr/local/vesta/data/ips/$NEWIPV4
mv /etc/apache2/conf.d/$OLDIPV4.conf /etc/apache2/conf.d/$NEWIPV4.conf
mv /etc/nginx/conf.d/$OLDIPV4.conf /etc/nginx/conf.d/$NEWIPV4.conf
grep -rl "$OLDIPV4" /usr/local/vesta/data | xargs sed -i "s#$OLDIPV4#$NEWIPV4#g"

service bind9 restart
service apache2 restart
service nginx restart
service vesta restart
