#!/bin/bash

for IP in `cat iplist`
do
	#ansible ${IP} -m shell -a 'df -TH | grep logBakServer'
	ansible-playbook mount_cifs.yaml -e host=${IP}
done
