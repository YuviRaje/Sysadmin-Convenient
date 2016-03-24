#!/bin/bash

SED_BIN=/usr/bin/sed
if [ ! -x "$SED_BIN" ]; then
  SED_BIN=sed
fi
GREP_BIN=/usr/bin/grep
if [ ! -x "$GREP_BIN" ]; then
  GREP_BIN=grep
fi
RPM_BIN=/bin/rpm
if [ ! -x "$RPM_BIN" ]; then
  RPM_BIN=rpm
fi
ECHO_BIN=/bin/echo
if [ ! -x "$ECHO_BIN" ]; then
  ECHO_BIN=echo
fi
LS_BIN=/bin/ls
if [ ! -x "$LS_BIN" ]; then
  LS_BIN=ls
fi
baseVer=-1.0.0
idVer="${baseVer}-1"
listA=`$LS_BIN *.rpm`
for j in $listA; do
  check=""
  name=`$ECHO_BIN $j | $SED_BIN 's/-[01]\.[01].*$//'`
  if [[ "$name" =~ "brs-" ]]; then
    if [[ "$name" =~ "config" ]]; then
      newname="policy$idVer"
      check=`$RPM_BIN -qa | $GREP_BIN $newname`
      if [ "$check" == "" ]; then
        check=`$RPM_BIN -qa | $GREP_BIN $name`
      fi
    else
      name=`$ECHO_BIN $name | $SED_BIN 's/^brs-//'`
      newname="$name$baseVer"
      check=`$RPM_BIN -qa | $GREP_BIN $newname`
      if [ "$check" == "" ]; then
        newname="${name}-rpm$baseVer"
        check=`$RPM_BIN -qa | $GREP_BIN $newname`
      fi
    fi
  else
    idname=$name$idVer
    check=`$RPM_BIN -qa | $GREP_BIN $idname`
    if [ "$check" == "" ]; then
      check=`$RPM_BIN -qa | $GREP_BIN $name`
    fi
  fi
  if [ "$check" != "" ]; then
    $RPM_BIN -e $check
    $ECHO_BIN Removing[$j]
  else
    $ECHO_BIN Nothing to do[$j]
  fi
done
