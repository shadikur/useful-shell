#!/bin/sh

# Author : M Rahman
# Copyright (c) shadikur.com
# Script follows here:

#Go to directory
mkdir -p /opt/autoclean
cd /opt/autoclean
wget https://raw.githubusercontent.com/shadikur/useful-shell/master/autoclean.sh


#Set Cron
echo " * * * * * bash /usr/src/autoclean.sh 2>&1 > /opt/autoclean.log" >> /var/spool/cron/root

#Restart Cron
systemctl crond restart
