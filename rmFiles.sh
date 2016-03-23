#!/bin/bash



#rm -rf /opt/emc/ucas/apache-tomcat-6.0.32/activemq-data-kaha    #remove any kaha data files

rm -f /tmp/networker-messages.log*

rm -f /opt/emc/ucas/apache-tomcat-6.0.32/logs/catalina*


rm -rf  /var/log/mongo/mongod.log

rm -rf /opt/emc/ucas/apache-tomcat-6.0.32/temp/mongod.log

rm -rf /tmp/logs/mongod.log

rm -rf /opt/emc/ucas/ucas-logs/activemq-messages* networker-messages.* ucas.* avamar-messages.*

rm -rf /opt/emc/ucas/apache-tomcat-6.0.32/logs/catalina.*

rm -rf /opt/emc/ucas/activemq-data-kaha/db-* db.* lock*

