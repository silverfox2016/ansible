#/bin/bash
source /home/oracle/.bash_profile
dbfilesize=`sqlplus -s zabbix/pmph2019  <<EOF
select to_char(sum(bytes/1024/1024/1024), 'FM99999999999999990') retvalue from dba_data_files;
EXIT;
EOF`
echo ${dbfilesize} | awk '{print $NF}'
