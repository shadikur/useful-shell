#!/bin/sh

# Author : M Rahman
# Copyright (c) shadikur.com
# Script follows here:

#Find files in the recording older than 10 min & delete
find /var/lib/freeswitch/recordings/ -type f -mmin +10 -delete

#Final old freeswitch log and delete
rm -rf /var/log/freeswitch/freeswitch.log.*

#Find Maillog and delete
rm -rf /var/log/maillog*
