#!/bin/bash

###############################################################################
# The script is used to remove the components or services logs from the system
# @author - Yuvraj Jadhav
###############################################################################
TOUCH_BIN=/usr/bin/touch
if [ ! -x "$TOUCH_BIN" ]; then
  TOUCH_BIN=touch
fi
FIND_BIN=/usr/bin/find
if [ ! -x "$FIND_BIN" ]; then
  FIND_BIN=find
fi
RM_BIN=/bin/rm
if [ ! -x "$RM_BIN" ]; then
  RM_BIN=rm
fi
DATE_BIN=/bin/date
if [ ! -x "$DATE_BIN" ]; then
  DATE_BIN=date
fi

dateFile=tempDate
brsParentDir=/usr/local/brs
brsLogDir=$brsParentDir/log/
brsZooDir=$brsParentDir/zookeeper/dataDir/version-2/
commitDir=/emc-catalog/commitlog/
varLogDir=/var/log
catalogLogDir=$varLogDir/catalog/
cassandraLogDir=$varLogDir/cassandra/ok as LogCon
currentDate=`$DATE_BIN +"%Y-%m-%d %H:%M"`

cd /tmp
$RM_BIN -f $dateFile
$TOUCH_BIN --date "$currentDate" $dateFile
for i in $brsLogDir $brsZooDir $commitDir $catalogDir $cassandraLogDir; do
  listLog=`$FIND_BIN $i -type f ! -newer $dateFile`
  $RM_BIN -f $listLog
done
$RM_BIN -f $dateFile
cd
