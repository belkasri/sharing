#!/bin/bash
set +e

DJ_HOST=openam-01.gp.ocean.com
DJ_ADMIN="cn=Directory Manager"
DJ_ADMIN_PWD="admin1234"
DJ_PORT=389
DJ_PATH="/app/opendj-generic"
DJ_BASE_DN="dc=example,dc=com"
DJ_USERS_BASE_DN="ou=people,dc=example,dc=com"
DJ_STATUS="results/dj_status.txt"
DJ_USER_COUNT="results/dj_user_count.txt"
DJ_MONITOR_FILE="results/dj_monitor.txt"
DJ_JVM_FILE="results/dj_jvm.txt"


# Server Status
time_now=`date +"%F %T"`; line_srv_status=`$DJ_PATH/bin/status -D "${DJ_ADMIN}" -w "${DJ_ADMIN_PWD}" -X -n |  grep -e "Server Run Status:" -e "Entries:"`; echo $time_now $line_srv_status >> ${DJ_STATUS}

# only if dj is running
if [[ $line_srv_status =~ .*Started.* ]]
then
  # user count
  time_now=`date +"%F %T"`; line_srv_users=`$DJ_PATH/bin/ldapsearch -X -h "${DJ_HOST}" -p "${DJ_PORT}" -D "${DJ_ADMIN}" -w "${DJ_ADMIN_PWD}" --baseDN "${DJ_USERS_BASE_DN}"  --countentries "(objectClass=*)" | grep -e '# Total number of matching entries:' `; echo $time_now $line_srv_users >> ${DJ_USER_COUNT}

  # Monitor output
  time_now=`date +"%F %T"`; line_srv_mon=`$DJ_PATH/bin/ldapsearch -X -h "${DJ_HOST}" -p "${DJ_PORT}" -D "${DJ_ADMIN}" -w "${DJ_ADMIN_PWD}" --baseDN "cn=monitor" -s sub "(objectclass=*)" | grep -e 'upTime:' -e 'currentConnections:' -e 'maxConnections:' -e 'totalConnections:' -e 'cn: userRoot backend' -e 'disk-dir:' -e 'disk-free:'`; echo $time_now $line_srv_mon > ${DJ_MONITOR_FILE}

  # JVM status
  time_now=`date +"%F %T"`; line_srv_jvm=`$DJ_PATH/bin/ldapsearch -X -h "${DJ_HOST}" -p "${DJ_PORT}" -D "${DJ_ADMIN}" -w "${DJ_ADMIN_PWD}" --baseDN "cn=JVM Memory Usage,cn=monitor" -s sub "(objectclass=*)"  `; echo $time_now $line_srv_jvm > ${DJ_JVM_FILE}
fi
