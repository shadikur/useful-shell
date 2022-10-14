#!/bin/sh

# Author : M Rahman
# Copyright (c) shadikur.com
# Script follows here:

#Go to directory
mkdir -p /opt/autoclean
cd /opt/autoclean
wget https://raw.githubusercontent.com/shadikur/useful-shell/master/autoclean.sh
chmod +x /opt/autoclean/autoclean.sh


#Set Cron
echo " * * * * * bash /opt/autoclean/autoclean.sh 2>&1 > /opt/autoclean.log" >> /var/spool/cron/root

#Restart Cron
service cron restart
