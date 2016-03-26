#!/bin/bash
SERVICE1=/usr/local/brs/scheduler
if result1=$(ps -ef | grep -v $SERVICE1)
echo PID: ${#result}
then
        echo "scheduler service is running"
else
        echo "Scheduler service is NOT running" 
fi
SERVICE2=/usr/local/brs/configmgr
if result2=$(ps -ef | grep -v $SERVICE2)
then
        echo "Configmgr service is running"
else
        echo "Configmgr service is NOT running"
fi
SERVICE3=/usr/local/brs/restserver
if result3=$(ps -ef | grep -v $SERVICE)
then
        echo "Restserver service is running"
else
        echo "Restserver service is NOT running"
fi
SERVICE4=/usr/local/brs/Sysmgr
if result4=$(ps -ef | grep -v $SERVICE4)
then
        echo "Sysmgr-application service is running"
else
        echo "Sysmgr-application service is NOT running"
fi
SERVICE5=/usr/local/brs/eventservice
if result5=$(ps -ef | grep -v $SERVICE5)
then
        echo "event service is running"
else
        echo "event service is NOT running"
fi







