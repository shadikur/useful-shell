#!/bin/sh

#Script Name: WordPress Quick Installation including Webserver
#Author: M S Rahman
#Copyright (c) shadikur.com
#Email: me@shadikur.com

#All the variables
bold=$(tput bold)
normal=$(tput sgr0)
green=$(tput setaf 2)

#Prepare Server

echo "${bold}Current RAM${normal}"
free -m
#
echo "\n"
echo "${bold}System updating ... \n"
apt update -y && apt -y upgrade && apt install build-essential -y && apt install wget git zip unzip vim nano dialog curl lsb-release -y
echo  "\n${bold}${green}System upgrade complete.${normal} \n"

#SWAP memory
echo "For better performance on processing, we can create virtual RAM (SWAP Memory) on your system"
echo "Do you want to proceed ? For yes Press y/Y  and n/N for NO: "
read RESPONSE

if [ ${RESPONSE} =  "y" ];
	then
	echo "Enter the memory that you want to make your SWAP in Mega Byte (e.g. 1024)"
	read MEMORY
	echo "\n${bold}Processing...Please wait.${normal}\n"
	cd /var
	touch swap.img
	chmod 600 swap.img
	dd if=/dev/zero of=/var/swap.img bs=${MEMORY}k count=1000
	echo  "${bold}${green}SWAP Processed Successfully${normal}\n"
	mkswap /var/swap.img
	swapon /var/swap.img
	echo "/var/swap.img    none    swap    sw    0    0" >> /etc/fstab
	sysctl -w vm.swappiness=30
	echo  "${bold}${green}SWAP Memory added successfully.${normal}\n"
else 
	echo "${bold}Sorry SWAP created aborted${normal}"
fi

#Webserver, DB and PHP
apt install nginx expect mysql-server php -y

SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"$MYSQL\r\"
expect \"Change the root password?\"
send \"n\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")

echo "$SECURE_MYSQL"
echo "MYSQL is ready for use\n"
apt-get  -y purge expect
echo "WordPress Donwloading...\n"
cd /var//wwww/html
wget https://en-gb.wordpress.org/latest-en_GB.zip
unzip latest*.zip
rm -rf latest*
cd wordpress
mv * ..
rm -rf wordpress

echo "\n${bold}${green}our site is ready. Please configure the standard settings by visiting on a web browser.${normal}"
