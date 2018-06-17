#!/bin/bash
set +e

ACTION_COUNT="results/activities_count.txt"

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


