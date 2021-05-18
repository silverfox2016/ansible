#/bin/bash
source /home/oracle/.bash_profile
dbfilesize=`sqlplus -s zabbix/pmph2019  <<EOF
select total_mb from v\\$asm_diskgroup where GROUP_NUMBER = 1;
EXIT;
EOF`
if [[ "${dbfilesize}" =~ "rows" ]];then
        echo 0
else
   echo ${dbfilesize} | awk '{print $NF}'
fi
#echo ${dbfilesize} 
