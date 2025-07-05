#!/bin/bash

#This script tells the LB whether the queried instance should be active on this host

#file for contains the desired states for every instance
baseline=$(dirname $0)/switch_list
debug=0
#Read instance from STDIN and chomp it
read -r instance
instance=$( echo -e ${instance} | sed -e 's/[[:space:]]$//' )
if [[ $debug -eq 1 ]]; then
        echo $instance >> /tmp/switch_debug_log
        echo $instance > /tmp/switch_debug_log2
fi

#First lets see if we actually want to be online
if [[ $( grep "^${instance}:" ${baseline} | awk -F: '{print $NF}' ) != "on" ]]; then
        echo -n "OFFLINE"
        exit 0
fi

#Is the wanted instance actually running?
if ! [[ $( ps -ef | grep -v grep | grep my.${instance}.cnf ) ]]; then
        echo -n "OFFLINE"
        exit 0
#If the instance is running, connect and we if it is actually part of the cluster
elif [[ $( mysql --defaults-file=/usr/lib64/nagios/plugins/aku/.my.cnf --defaults-group-suffix=_monitoring -ss -S /mysql/${instance}/mysql.sock -e "show global status like 'wsrep_ready';" | awk '{print $NF}' ) == ON ]]; then
        echo -n "ONLINE"
        exit 0
#If we actually get this far, the instance should be up and runnning properly
else
        echo -n "OFFLINE"
        exit 0
fi

