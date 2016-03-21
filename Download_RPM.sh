#!/bin/bash
##########################################################################################
#
# Purpose:This script will download the various Hv2 component RPMs from the Nexus server.
# If the Maven server is inaccessible then this script will not download the RPMs.
# Last Updated on: 12-12-2014
#
##########################################################################################

DLT_FILE=/tmp/DLT-FILE.txt
GREP_BIN=/usr/bin/grep
if [ ! -x "$GREP_BIN" ]; then
  GREP_BIN=grep
fi
SED_BIN=/usr/bin/sed
if [ ! -x "$SED_BIN" ]; then
  SED_BIN=sed
fi
WGET_BIN=/usr/bin/wget
if [ ! -x "$WGET_BIN" ]; then
  WGET_BIN=wget
fi
AWK_BIN=/usr/bin/awk
if [ ! -x "$AWK_BIN" ]; then
  AWK_BIN=awk
fi
RM_BIN=/bin/rm
if [ ! -x "$RM_BIN" ]; then
  RM_BIN=rm
fi
RPM_BIN=/bin/rpm
if [ ! -x "$RPM_BIN" ]; then
  RPM_BIN=rpm
fi
CP_BIN=/bin/cp
if [ ! -x "$CP_BIN" ]; then
  CP_BIN=cp
fi
ECHO_BIN=/bin/echo
if [ ! -x "$ECHO_BIN" ]; then
  ECHO_BIN=echo
fi
SnapRPMVer=1.0.0
snapshotRPMDirectory=${SnapRPMVer}-SNAPSHOT
# This is the repolocation=http://maven-sc.lss.emc.com:8081/nexus/content/groups/public/com/emc/brs 
repolocation=http://10.13.202.222:8081/nexus/content/groups/public/com/emc/brs
eventserviceRPM=$repolocation/eventservice/brs-eventservice/$snapshotRPMDirectory/
loggingRPM=$repolocation/logging/brs-logging/$snapshotRPMDirectory/
schedulerRPM=$repolocation/scheduler/brs-scheduler/$snapshotRPMDirectory/
restservicesRPM=$repolocation/restservices/brs-rest/$snapshotRPMDirectory/
configmgrRPM=$repolocation/configmgr/brs-configmgr/$snapshotRPMDirectory/
policyengineRPM=$repolocation/protection/policyengine/$snapshotRPMDirectory/
protectionRPM=$repolocation/protection/brs-protmgr/$snapshotRPMDirectory/
nwcpeRPM=$repolocation/protection/brs-nwcpe/$snapshotRPMDirectory/
avpeRPM=$repolocation/protection/brs-avpe/$snapshotRPMDirectory/
avspeRPM=$repolocation/protection/brs-avspe/$snapshotRPMDirectory/
sysmgrRPM=$repolocation/sysmgr/brs-sysmgr/$snapshotRPMDirectory/
RPMsList="$loggingRPM $restservicesRPM $configmgrRPM $schedulerRPM  $eventserviceRPM $policyengineRPM $protectionRPM $avpeRPM $avspeRPM $nwcpeRPM $sysmgrRPM"
#RPMsList=Harmony Components RPM  packages
preVer=-$SnapRPMVer
newVer="${preVer}-1"
if [ "$1" != "" ]; then
  rpmExpList=$1
else
  rpmExpList=
fi

#set -x
for i in $RPMsList; do
  rpmList=""
  if [ "$rpmExpList" != "" ]; then
    $WGET_BIN -O - $i > $DLT_FILE 2>&1
    rpmList=`$GREP_BIN "\.rpm<" $DLT_FILE | $SED_BIN -e 's/^.*=\"//' -e 's/\">.*$//'`
    u=
    for j in $rpmExpList; do
      u=`$ECHO_BIN $rpmList | $GREP_BIN $j`
      if [ "$u" != "" ]; then
        u=$j
        break
      fi
    done
    if [ "$u" != "" ]; then
      rpmList=$i/$u
    else
      rpmList=""
    fi
  fi
  if [ "$rpmList" == "" ]; then 
    $WGET_BIN -O - $i > $DLT_FILE 2>&1
    rpmList=`$GREP_BIN "\.rpm<" $DLT_FILE | $SED_BIN -e 's/^.*=\"//' -e 's/\">.*$//' | $AWK_BIN 'END{print}'`
  fi
  rpmFile=`$ECHO_BIN $rpmList | $SED_BIN 's/^.*\///'`
  if [ -f "$rpmFile" ]; then
    $RM_BIN $rpmFile
  fi
  $WGET_BIN $rpmList 2>/dev/null
  if [ $? != 0 ]; then
    if [ -f "$rpmFile" ]; then
      $RM_BIN $rpmFile
    fi
    $WGET_BIN $rpmList 2>/dev/null
  fi
  if [ ! -f $rpmFile ]; then
    $ECHO_BIN Missing: $i
  fi
  check=""
  RPMname=`$ECHO_BIN $rpmFile | $SED_BIN 's/-[01]\.[01].*$//'`
  if [[ "$RPMname" =~ "brs-" ]]; then
    if [[ "$RPMname" =~ "config" ]]; then
      check=`$RPM_BIN -qa | $GREP_BIN policy$newVer`
    elif [[ "$RPMname" =~ "logging" ]]; then
      check=`$RPM_BIN -qa | $GREP_BIN logging-logmanager$newVer`
    else
      check=`$RPM_BIN -qa | $GREP_BIN $RPMname$newVer`
      if [ "$check" == "" ]; then
        newRPMname=`$ECHO_BIN $RPMname | $SED_BIN 's/^brs-//'`
        check=`$RPM_BIN -qa | $GREP_BIN $newRPMname$preVer`
        if [ "$check" == "" ]; then
          check=`$RPM_BIN -qa | $GREP_BIN ${newRPMname}-rpm$preVer`
          if [ "$check" == "" ]; then
            check=`$RPM_BIN -qa | $GREP_BIN ${newRPMname}-rpm`
          fi
        fi
      fi
    fi
  fi
  if [ "$check" == "" ]; then
    check=`$RPM_BIN -qa | $GREP_BIN $RPMname`
    if [ "$check" == "" ]; then
      check=`$RPM_BIN -qa | $GREP_BIN $RPMname$newVer`
    fi
  fi
  result=1
  if [ "$check" != "" ]; then
    $RPM_BIN -Uvh --replacepkgs --replacefiles $rpmFile
    result=$?
    if [ $result != 0 ]; then
      $RPM_BIN -e $check
      result=1
    fi
  fi
  if [ $result != 0 -a -f "$rpmFile" ]; then
    $RPM_BIN -ivh $rpmFile
  fi
done
