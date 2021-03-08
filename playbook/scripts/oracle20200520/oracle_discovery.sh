#!/bin/bash
TABLESPACE=$(cat /home/oracle/tablespace.log |awk '$0~ "ONLINE" NR>2{print $2}')
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
