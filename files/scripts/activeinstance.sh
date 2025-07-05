#!/bin/bash


#showzero=yes
showzero=no

for instance in $(ps -ef | grep 'mysqld ' | grep -Po 'datadir=/mysql/[\d\w-]*' | awk -F\/ '{print $3}'); do
	port=$(cat /etc/mysql/my.${instance}.cnf  | grep -m1 port | awk '{print $NF}')
	list=$(lsof -nlPi | grep mysqld | grep ":${port}-" | grep 'ESTABLISHED')
	count=$(echo  "$list" | wc -l)
	if [ -z "$list" ] ; then 
		count=0
	fi
	if [ $count -gt 0 ] || [ "$showzero" == "yes" ]; then
		echo  "$instance ------------------------------------------------ "
		echo "    $count active Connections"
		if [ $count -gt 0 ] ; then
			echo "$list" | awk '{print $9}' | awk -F\> '{print $2}' | awk -F\: '{print $1}' | sort | uniq -c | awk '{ cmd = "dig +short -x " $2; cmd | getline HOSTNAME; close( cmd );print "      " $1 " " $2 " " HOSTNAME}'
		fi
	echo ""
	fi
done
