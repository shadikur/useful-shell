#!/bin/bash
cpuuse=$(cat /proc/loadavg | awk '{print $1}')

if [ "$cpuuse" > 80 ]; then

SUBJECT="ATTENTION: CPU Load Is High on $(hostname) at $(date)"

MESSAGE="/tmp/Mail.out"

TO="me@shadikur.com"

  echo "CPU Current Usage is: $cpuuse%" >> $MESSAGE

  echo "" >> $MESSAGE

  echo "+------------------------------------------------------------------+" >> $MESSAGE

  echo "Top CPU Process Using top command" >> $MESSAGE

  echo "+------------------------------------------------------------------+" >> $MESSAGE

  echo "$(top -bn1 | head -20)" >> $MESSAGE

  echo "" >> $MESSAGE

  echo "+------------------------------------------------------------------+" >> $MESSAGE

  echo "Top CPU Process Using ps command" >> $MESSAGE

  echo "+------------------------------------------------------------------+" >> $MESSAGE

  echo "$(ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10)" >> $MESSAGE

  mail -s "$SUBJECT" "$TO" < $MESSAGE

  rm /tmp/Mail.out

  fi