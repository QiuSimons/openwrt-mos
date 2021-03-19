#!/bin/sh
PATH="/usr/sbin:/usr/bin:/sbin:/bin"
logread -e MosDNS > /tmp/MosDNStmp.log
logread -e MosDNS -f >> /tmp/MosDNStmp.log &
pid=$!
echo "1">/var/run/MosDNSsyslog
while true
do
	sleep 12
	watchdog=$(cat /var/run/MosDNSsyslog)
	if [ "$watchdog"x == "0"x ]; then
		kill $pid
		rm /tmp/MosDNStmp.log
		rm /var/run/MosDNSsyslog
		exit 0
	else
		echo "0">/var/run/MosDNSsyslog
	fi
done