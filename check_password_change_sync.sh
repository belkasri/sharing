#!/bin/bash
set +e

DJ_HOST=openam-01.gp.ocean.com
DJ_ADMIN="cn=Directory Manager"
DJ_ADMIN_PWD="admin1234"
DJ_PORT=389
DJ_BASE_DN="dc=example,dc=com"
DJ_PATH="/app/opendj-generic"
DJ_TEST_USER="uid=user.0,ou=People,dc=example,dc=com"

# Test user password
TEST_USER_UID="user.0"
TEST_USER_CURR_PWD="password1234"
TEST_USER_NEW_PWD="admin1234"
PWD_CHANGE_STATUS="results/password_change_status.txt"

CA_HOST=openam-01.gp.ocean.com
CA_ADMIN="cn=Directory Manager"
CA_ADMIN_PWD="admin1234"
CA_PORT=389
CA_BASE_DN="dc=example,dc=com"
CA_TEST_USER="uid=user.0,ou=People,dc=example,dc=com"


# Change Password in DJ
echo "------------- Checking at `date +"%F %T"` ----------------" >> ${PWD_CHANGE_STATUS}
time_now=`date +"%F %T"`; line_dj_chg_pwd=`$DJ_PATH/bin/ldappasswordmodify -h ${DJ_HOST} -D "${DJ_ADMIN}" -w "${DJ_ADMIN_PWD}" -a "dn:${DJ_TEST_USER}" -c "${TEST_USER_CURR_PWD}" -n "${TEST_USER_NEW_PWD}"` 
if [[ $line_dj_chg_pwd =~ .*"was successful".* ]]
then
  echo $time_now "DJ password change successful" >> ${PWD_CHANGE_STATUS}
else
  echo $time_now "DJ password change failed" >> ${PWD_CHANGE_STATUS}    
fi

# allow some time for sync to happen
sleep 30

# Bind to CA with new password

time_now_ca=`date +"%F %T"`; line_ca_bind=`$DJ_PATH/bin/ldapsearch -X -h ${CA_HOST} -p "${CA_PORT}" -D "${CA_TEST_USER}" -w "${TEST_USER_NEW_PWD}" --baseDN "${CA_BASE_DN}" -s sub "(uid=${TEST_USER_UID})" | grep -e "uid: ${TEST_USER_UID}"`
match_pattern="uid: `echo ${TEST_USER_UID}`" 
if [[ $line_ca_bind =~ .*"${match_pattern}".* ]]
then
  echo $time_now_ca "CA: Password has been synced sucessfully " >> ${PWD_CHANGE_STATUS}
else
  echo $time_now_ca "CA: Password failed to syc" >> ${PWD_CHANGE_STATUS}    
fi


# Change Password Back in DJ -- this is to make sure that the script can run again
time_now2=`date +"%F %T"`; line_dj_chg_pwd2=`$DJ_PATH/bin/ldappasswordmodify -h ${DJ_HOST} -D "${DJ_ADMIN}" -w "${DJ_ADMIN_PWD}" -a "dn:${DJ_TEST_USER}" -c "${TEST_USER_NEW_PWD}" -n "${TEST_USER_CURR_PWD}"` 
if [[ $line_dj_chg_pwd2 =~ .*"was successful".* ]]
then
  echo $time_now2 "DJ password change back successful - preparing for next run!" >> ${PWD_CHANGE_STATUS}
else
  echo $time_now2 "DJ password change back failed" >> ${PWD_CHANGE_STATUS}    
fi
echo "-------------------------------------------------------" >> ${PWD_CHANGE_STATUS}
