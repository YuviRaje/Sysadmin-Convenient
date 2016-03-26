#!/bin/bash
getpid() {
 ps -efww | grep $1 | grep -v "grep" | sed -e "s/^ *[^ ]* *\([^ ]*\).*/\1/"
echo $1 is running at PID  
}

getpid logging
getpid tomcat
getpid restserver
getpid scheduler
getpid zookeeper

ps axo pid,command |grep java >& /tmp/java.txt
perl -ne 'while(/^.*\ (\S+)$/g){print "$1\n";}' /tmp/java.txt


