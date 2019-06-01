#!/bin/sh

# Author : M Rahman
# Copyright (c) shadikur.com
# Script follows here:

echo "Current RAM"
free -m
#
echo "System updating ... "
apt update -y && apt -y upgrade && apt install build-essential -y && apt install wget git zip unzip vim nano dialog curl lsb-release -y
echo "System upgrade complete."

#SWAP memory
echo "For better performance on processing, we can create virtual RAM (SWAP Memory) on your system"
echo "Do you want to proceed ? For yes Press y/Y  and n/N for NO: "
read RESPONSE

if [ $RESPONSE =  "y" ];
	then
	echo "Enter the memory that you want to make your SWAP in Mega Byte (e.g. 1024)"
	read MEMORY
	cd /var
	touch swap.img
	chmod 600 swap.img
	dd if=/dev/zero of=/var/swap.img bs=${MEMORY}k count=1000
	echo "SWAP Processed Successfully"
	mkswap /var/swap.img
	swapon /var/swap.img
	echo "/var/swap.img    none    swap    sw    0    0" >> /etc/fstab
	echo "SWAP Memory added successfully."
	sysctl -w vm.swappiness=30
else 
	echo "Sorry SWAP created aborted"
fi

#
echo "Updated RAM and SWAP"
free -m

echo "System Disk Status"
df -h


