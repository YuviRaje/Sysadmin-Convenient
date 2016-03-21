#!/bin/bash

# Another way to get rid of logs with combined commands

#Variables
LOGS_DIRECTORY=/var/log/brs/
LOGS_DIRECTORY_EXT=/var/log

echo "Accss the Log Directory"

rm -vf ${LOGS_DIRECTORY}/catalog-cassandra/catalog-cassandra.*
rm -vf /usr/local/brs/zookeeper/dataDir/version-2/log.*

echo " Remove the Logs"
# Remove Logs
rm -vf ${LOGS_DIRECTORY}/sysmgr/*sysmgr* ${LOGS_DIRECTORY}/authservice/*authservice* ${LOGS_DIRECTORY}/discovery-service/*discovery-service* 
${LOGS_DIRECTORY}/sla-service/*sla-service* ${LOGS_DIRECTORY}/restserver/*restserver* ${LOGS_DIRECTORY}/scheduler/*scheduler* ${LOGS_DIRECTORY}/configmgr/*configmgr* 

rm -vf ${LOGS_DIRECTORY_EXT}/YaST2/*y2log* ${LOGS_DIRECTORY_EXT}/cassandra/system.log ${LOGS_DIRECTORY_EXT}/zypp/history ${LOGS_DIRECTORY_EXT}/rabbitmq/*rabbitmq*

rm -vf ${LOGS_DIRECTORY_EXT}/zypper.log 
rm -vf ${LOGS_DIRECTORY_EXT}/lastlog


echo "[INFO]:Logs are cleaned"

exit # Exit from the script.
