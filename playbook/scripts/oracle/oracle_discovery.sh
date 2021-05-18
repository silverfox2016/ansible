#!/bin/bash
TABLESPACE=$(cat /home/oracle/zabbixXJ.log | awk '/Tablespace/ {print $4}')
COUNT=$(echo "$TABLESPACE" |wc -l)
INDEX=0
echo '{"data":['
echo "$TABLESPACE" | while read LINE; do
    echo -n '{"{#TABLENAME}":"'$LINE'"}'
    INDEX=`expr $INDEX + 1`
    if [ $INDEX -lt $COUNT ]; then
        echo ','
    fi
done
echo ']}'
