#!/bin/bash
set +e

CA_HOST=openam-01.gp.ocean.com
CA_ADMIN="cn=Directory Manager"
CA_ADMIN_PWD="admin1234"
CA_PORT=389
CA_BASE_DN="dc=example,dc=com"
CA_USERS_BASE_DN="ou=people,dc=example,dc=com"
CA_STATUS="results/ca_status.txt"
CA_USER_COUNT="results/ca_user_count.txt"


# Server Status
time_now=`date +"%F %T"`; line_srv_status=`$DJ_PATH/bin/status -D "${DJ_ADMIN}" -w "${DJ_ADMIN_PWD}" -X -n |  grep "Server Run Status:"`; echo $time_now $line_srv_status >> ${DJ_STATUS}

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
