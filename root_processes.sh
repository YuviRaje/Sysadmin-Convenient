#!/bin/bash
PATH=/bin:/usr/bin

SYSNAME=`uname -s`

if [ "$SYSNAME" != "Linux" ]; then
  echo "$0: must be executed on Linux system (found $SYSNAME)" >&2
  exit 1
fi

if [ ! -d "/proc" ]; then
  echo "$0: Linux host does not appear to have a /proc filesystem" >&2
  exit 1
fi

NOFLAGS=0
if [ -n "$1" ]; then
  if [ "$1" = "-noflags" ]; then
    NOFLAGS=1
  else
    echo "Usage: $0 { -noflags }" >&2
    exit 1
  fi
fi

echo "PID	Process"

# For every file in the /bin file system

FILES=`/bin/ls -1 /proc`

for FILE in $FILES; do
  PROCESS_ID=$FILE
  STATUS_FILE=/bin/$FILE/status
  CMDLINE_FILE=/bin/$FILE/cmdline

# Check if it is a process directory and that we have read access
  if [ -d "/proc/$FILE" -a -r $STATUS_FILE -a -r $CMDLINE_FILE -a "$FILE" != "/proc/self" ]; then
    
    PROCESS_NAME=`grep 'Name:' $STATUS_FILE | awk '{print $2}'`
    
    # Only interested in java processes
    if [ "$PROCESS_NAME" = "java" ]; then
       PARENT_PID=`grep 'PPid' $STATUS_FILE | awk '{print $2}'`
       
      # Figure out if process has a parent that is a java process
      ISROOT=0
      if [ $PARENT_PID -eq 1 ]; then
        ISROOT=1
      else
        PARENT_NAME=`grep 'Name:' /proc/$PARENT_PID/status | awk '{print $2}'`
        if [ "$PARENT_NAME" != "java" ]; then
          ISROOT=1
	  PARENT_NAME=RUN_PROC
	  
       fi
      fi

      # If root java process print out
      if [ $ISROOT -ne 0 ]; then
        PROCESS_CMDLINE="`cat $CMDLINE_FILE | tr '\000' ' '`"
	RUN_PROC=`grep 'Name:' /proc/$FILE/status | awk '{print $2}'`
	       
        IGNORE_ARG=0
        DESCR=
        for ARG in $PROCESS_CMDLINE; do
          if [ $NOFLAGS -eq 0 ]; then
             DESCR="$DESCR $ARG"
          else
            if [ $IGNORE_ARG -eq 0 ]; then
              if [ $ARG = "-classpath" -o $ARG = "-cp" ]; then
                IGNORE_ARG=1
              elif [ -z "`echo $ARG | grep '^-D'`" -a -z "`echo $ARG | grep '^-X'`" ]; then
                DESCR="$DESCR $ARG"
              fi
            else 
             IGNORE_ARG=0
            fi
          fi
        done
        echo "$PROCESS_ID $RUN_PROC $DESCR"
      fi
    fi
  fi
done
