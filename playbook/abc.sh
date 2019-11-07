#!/bin/bash

for IP in `cat iplist`
do
	#ansible ${IP} -m shell -a 'df -TH | grep logBakServer'
	ansible-playbook zabbix_agent.yml -e host=${IP}
done
