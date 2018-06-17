#!/bin/bash
set +e

DJ_STATUS="results/dj_status.txt"
DJ_MONITOR="results/dj_monitor.txt"
PWD_CHANGE_STATUS="results/password_change_status.txt"

# Server Status
time_now=`date +"%F %T"`; line_srv_status=`echo "Server Run Status: Stopped"`; echo $time_now $line_srv_status >> ${DJ_STATUS}

# low memory
time_now=`date +"%F %T"`; echo $time_now "disk-free: 123" >> ${DJ_MONITOR}


# password change
PWD_CHANGE_STATUS="results/password_change_status.txt"
echo `date +"%F %T"` "CA: Password failed to syc" >> ${PWD_CHANGE_STATUS}

