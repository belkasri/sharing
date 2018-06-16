#!/bin/bash
set +e

IDM_LOG="recon.audit.json-abdel.txt"
ACTION_COUNT="/tmp/activities_count.txt"


# updates count
time_now=`date +"%F %T"`; line_updates=`cat ${IDM_LOG} | grep '\"action\":\"UPDATE\",\"exception\":null' | wc -l`; echo $time_now "Update Count:" $line_updates >> ${ACTION_COUNT}

# creates count
time_now=`date +"%F %T"`; line_creates=`cat ${IDM_LOG} | grep '\"action\":\"CREATE\",\"exception\":null' | wc -l`; echo $time_now "Creation Count:" $line_creates >> ${ACTION_COUNT}

# deletes count
time_now=`date +"%F %T"`; line_deletes=`cat ${IDM_LOG} | grep '\"action\":\"DELETE\",\"exception\":null' | wc -l`; echo $time_now "Deletion Count:" $line_deletes >> ${ACTION_COUNT}
