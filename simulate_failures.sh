#!/bin/bash
set +e

DJ_STATUS="results/dj_status.txt"
DJ_MONITOR="results/dj_monitor.txt"
ACTION_COUNT="results/activities_count.txt"
PWD_CHANGE_STATUS="results/password_change_status.txt"

# Server Status
time_now=`date +"%F %T"`; line_srv_status=`echo "Server Run Status: Stopped"`; echo $time_now $line_srv_status >> ${DJ_STATUS}

# low memory
time_now=`date +"%F %T"`; echo $time_now "disk-free: 123" >> ${DJ_MONITOR}

# activities count
echo `date +"%F %T"` "Update Count: 0" >> ${ACTION_COUNT}
echo `date +"%F %T"` "Creation Count: 1" >> ${ACTION_COUNT}
echo `date +"%F %T"` "Deletion Count: 0" >> ${ACTION_COUNT}
dateplus=`date +"%F %T" -d "+1 hours"`
echo $dateplus "Update Count: 2" >> ${ACTION_COUNT}
echo $dateplus "Creation Count: 1" >> ${ACTION_COUNT}
echo $dateplus "Deletion Count: 0" >> ${ACTION_COUNT}
dateplus=`date +"%F %T" -d "+2 hours"`
echo $dateplus "Update Count: 3" >> ${ACTION_COUNT}
echo $dateplus "Creation Count: 1" >> ${ACTION_COUNT}
echo $dateplus "Deletion Count: 0" >> ${ACTION_COUNT}

# password change
PWD_CHANGE_STATUS="results/password_change_status.txt"
echo `date +"%F %T"` "CA: Password failed to syc" >> ${PWD_CHANGE_STATUS}

