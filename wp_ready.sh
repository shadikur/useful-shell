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
apt install apache2 expect mysql-server php php-common php-cli php-mbstring  php-zip  php php-fpm php-mysql php-json php-readline php-xml php-curl php-gd php-json  php-opcache -y

#Password Create
echo "\n${bold}Please choose your MYSQL password: ${normal} \n"
read DBPASS

SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"$MYSQL\r\"
expect \"Change the root password?\"
send \"y\r\"
expect \"New password:\"
send  \"${DBPASS}\"
expect \"Re-enter new password:\"
send \"${DBPASS}\"
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
rm -rf /var/www/html/*
wget https://en-gb.wordpress.org/latest-en_GB.zip
unzip latest*.zip
rm -rf latest*
cp -R wordpress/* /var/www/html/
rm -rf wordpress
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
chown -R www-data:www-data /var/www/html/
apt autoremove -y

mysql -uroot -p${DBPASS} -e "CREATE DATABASE mywp;"
mysql -uroot -p${DBPASS} -e " CREATE USER 'mywp'@'localhost' IDENTIFIED BY '${DBPASS}';"
mysql -uroot -p${DBPASS} -e "GRANT ALL PRIVILEGES ON \`mywp\` . * TO 'mywp'@'localhost' WITH GRANT OPTION;FLUSH PRIVILEGES;"
echo "Database configured!\n"
sed -i "s#define( 'DB_NAME', 'database_name_here' );#define( 'DB_NAME', 'mywp' );#g" /var/www/html/wp-config.php
sed -i "s#define( 'DB_USER', 'username_here' );#define( 'DB_USER', 'mywp' );#g" /var/www/html/wp-config.php
sed -i "s#define( 'DB_PASSWORD', 'password_here' );#define( 'DB_PASSWORD', '${DBPASS}' );#g" /var/www/html/wp-config.php
service apache2 restart
service mysql restart
echo "\n  ${bold}${green}Your site is ready. Please configure the standard settings by visiting on a web browser.${normal}"

echo "\n  Please remember that your MYSQL Root Password is ${bold}${DBPASS}${normal}\n\n"