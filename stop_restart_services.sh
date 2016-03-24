#!/bin/bash

BRS=/usr/local/brs
echo stop catalog processes
${BRS}/catalog/catalog/bin/catalog-stop.sh 
rm -vf /var/log/cassandra/system.* /var/log/catalog/catalog.*

echo kill the skyline processes
ps -ef | grep -i protect | awk '{print $2}' | xargs kill -9
ps -ef | grep eventservice | awk '{print $2}' | xargs kill -9
ps -ef | grep ConfigManager | awk '{print $2}' | xargs kill -9
ps -ef | grep restserver | awk '{print $2}' | xargs kill -9
ps -ef | grep scheduler| awk '{print $2}' | xargs kill -9
ps -ef | grep PolicyEngine| awk '{print $2}' | xargs kill -9

echo remove logs
rm -vf ${BRS}/log/*prot* ${BRS}/log/*configmgr* ${BRS}/log/*eventservice* \
${BRS}/log/restserver* ${BRS}/log/scheduler* ${BRS}/log/policy*

echo restart the processes
${BRS}/catalog/catalog/bin/catalog-start.sh
${BRS}/bin/config_manager.sh
${BRS}/bin/eventservice.sh
${BRS}/bin/start_policy_engine.sh
${BRS}/bin/restserver.sh
${BRS}/bin/scheduler.sh
