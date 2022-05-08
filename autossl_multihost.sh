#!/bin/sh

# Author : M Rahman
# Copyright (c) shadikur.com
# Script follows here:

#get the flags as input value and process the request
while getopts "d:e:" opt; do
  case $opt in
    d) domain_name=$OPTARG;;
    e) email_address=$OPTARG;;
    *) echo 'error' >&2
       exit 1
  esac
done

#copy the apache configuration
cp /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/${domain_name}.conf

#enable apache configuration for SSL provisioning
sudo a2ensite ${domain_name}.conf

#run certbot script no interactively
certbot --apache -d ${domain_name} --non-interactive --agree-tos -m ${email_address} --redirect

#restart apache server
systemctl restart apache

