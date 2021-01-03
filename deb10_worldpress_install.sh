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
apt update -y && apt -y upgrade && apt install build-essential -y && apt install wget git zip gnupg unzip vim nano dialog curl lsb-release -y
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
apt-get -y install apt-transport-https lsb-release ca-certificates
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
apt-get update

#MySQL Server Installation
cd /tmp
wget https://dev.mysql.com/get/mysql-apt-config_0.8.13-1_all.deb
sudo dpkg -i mysql-apt-config*
apt update -y && apt -y upgrade
apt -y install unixodbc unixodbc-bin
debconf-set-selections <<< "mysql-community-server mysql-community-server/root-pass password ${MYSQL_ROOT_PASSWORD}"
debconf-set-selections <<< "mysql-community-server mysql-community-server/re-root-pass password ${MYSQL_ROOT_PASSWORD}"
debconf-set-selections <<< "mysql-community-server mysql-server/default-auth-override select Use Legacy Authentication Method (Retain MySQL 5.x Compatibility)"
DEBIAN_FRONTEND=noninteractive apt install -y mysql-server
apt install apache2 expect mysql-server php7.3 php7.3-common php7.3-cli php7.3-mbstring  php7.3-zip php7.3-fpm php7.3-mysql php7.3-json php7.3-readline php7.3-xml php7.3-curl php7.3-gd php7.3-json php7.3-imap php7.3-odbc php7.3-opcache libapache2-mod-php7.3 libapache2-mod-php -y

sudo a2dismod mpm_event && sudo a2enmod mpm_prefork && sudo a2enmod php7.3

#Update PHP Settings
sleep 2
sed 's#post_max_size = .*#post_max_size = 80M#g' -i /etc/php/7.3/fpm/php.ini
sed 's#upload_max_filesize = .*#upload_max_filesize = 80M#g' -i /etc/php/7.3/fpm/php.ini
sed 's#;max_input_vars = .*#max_input_vars = 8000#g' -i /etc/php/7.3/fpm/php.ini

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
echo "\n ${bold}${green}Database configured!${normal}\n"
sed -i "s#define( 'DB_NAME', 'database_name_here' );#define( 'DB_NAME', 'mywp' );#g" /var/www/html/wp-config.php
sed -i "s#define( 'DB_USER', 'username_here' );#define( 'DB_USER', 'mywp' );#g" /var/www/html/wp-config.php
sed -i "s#define( 'DB_PASSWORD', 'password_here' );#define( 'DB_PASSWORD', '${DBPASS}' );#g" /var/www/html/wp-config.php
service apache2 restart
service mysql restart
echo "\n  ${bold}${green}Your site is ready. Please configure the standard settings by visiting on a web browser.${normal}"

echo "\n  Please remember that your MYSQL Root Password is ${bold}${DBPASS}${normal}\n\n"