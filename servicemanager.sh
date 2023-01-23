#!/bin/bash
#Author: Mohammad Shadikur Rahman
# This is a shell script which will automatically set a cronjob in the Linux system for the following service
# 1. Freeswitch service will start at 6:PM and stop at 6:AM on weekdays and Saturday
# 2. Freeswitch service will stop all-time in Sunday

# Get current day of the week (0-6, with 0 being Sunday)
day=$(date +%u)

# Get current hour
hour=$(date +%H)

# Stop Freeswitch if it's a weekday and currently before 6am, or if it's Sunday
if [[ $day -ge 1 && $day -le 6 && $hour -lt 6 ]] || [[ $day -eq 0 ]]; then
  systemctl stop freeswitch
fi

# Start Freeswitch if it's a weekday and currently after 6pm and not Sunday
if [[ $day -ge 1 && $day -le 6 && $hour -ge 18 ]] && [[ $day -ne 0 ]]; then
  systemctl start freeswitch
fi
