#!/bin/bash

AWK_BIN=/usr/bin/awk
if [ ! -x "$AWK_BIN" ]; then
  AWK_BIN=awk
fi
GREP_BIN=/usr/bin/grep
if [ ! -x "$GREP_BIN" ]; then
  GREP_BIN=grep
fi
PS_BIN=/bin/ps
if [ ! -x "$PS_BIN" ]; then
  PS_BIN=ps
fi
KILL_BIN=/bin/kill
if [ ! -x "$KILL_BIN" ]; then
  KILL_BIN=kill
fi

killList="ConfigManager PolicyManager PolicyClient LoggingManager ProtectionManager Scheduler restserver Engine SysMgr eventservice"
for i in $killList; do
  psList=`$PS_BIN -edf | $GREP_BIN $i | $GREP_BIN -v grep | $AWK_BIN '{print $2}'`
  for j in $psList; do
    $KILL_BIN -9 $j
  done
done
/opt/emc/authc/tomcat/bin/shutdown.sh
/usr/local/brs/catalog/catalog/bin/catalog-stop.sh
/usr/local/brs/zookeeper/bin/zkServer.sh stop
service rabbitmq-server stop
killList="cassandra tomcat rabbitmq zookeeper"
for i in $killList; do
  psList=`$PS_BIN -edf | $GREP_BIN $i | $GREP_BIN -v grep | $AWK_BIN '{print $2}'`
  for j in $psList; do
    $KILL_BIN -9 $j
  done
done

