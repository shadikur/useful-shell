#!/bin/sh

# Author : M Rahman
# Copyright (c) shadikur.com
# Script follows here:

#All the variables
bold=$(tput bold)
normal=$(tput sgr0)
green=$(tput setaf 2)

echo "${bold}Current RAM${normal}"
free -m
#
echo "\n"
echo "${bold}System updating ... \n"
apt update -y && apt -y upgrade && apt install build-essential -y && apt install wget git zip unzip vim nano dialog curl lsb-release software-properties-common -y
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

#
echo "\n${bold}Updated RAM and SWAP${normal}"
free -m

echo  "\n${bold}System Disk Status${normal}"
df -h


