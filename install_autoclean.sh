#!/bin/sh

# Author : M Rahman
# Copyright (c) shadikur.com
# Script follows here:

#Go to directory
mkdir -p /opt/autoclean
cd /opt/autoclean
wget URL


#Set Cron
echo " * * * * * bash /usr/src/autoclean.sh 2>&1 > /opt/autoclean.log" >> /etc/crontab

#Restart Cron
systemctl cron restart
