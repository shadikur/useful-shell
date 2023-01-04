#!/bin/bash
#Author: Mohammad Shadikur Rahman
# This is a shell script which will automatically set a cronjob in the linux system for the following service
# 1. Freeswitch service will stop at 6:PM and start at 6:AM in weekdays and saturday
# 2. Freeswitch service will stop all the time in sunday

# Get current day of the week (0-6, with 0 being Sunday)
day=$(date +%u)

# Get current hour
hour=$(date +%H)

# Start Freeswitch if it's a weekday and currently before 6pm
if [[ $day -ge 1 && $day -le 6 ]] && [[ $hour -ge 6 && $hour -lt 18 ]]; then
  systemctl start freeswitch
fi

# Stop Freeswitch if it's a weekday and currently after 6pm, or if it's Sunday
if [[ $day -ge 1 && $day -le 6 && $hour -ge 18 ]] || [[ $day -eq 0 ]]; then
  systemctl stop freeswitch
fi