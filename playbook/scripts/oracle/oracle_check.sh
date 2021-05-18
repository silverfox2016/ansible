#!/bin/bash
EQ_DATA="$2"
ZBX_REQ_DATA_TAB="$1"
SOURCE_DATA=/home/oracle/zabbixXJ.log
case $2 in
  maxmb)       
    grep -w "$ZBX_REQ_DATA_TAB" $SOURCE_DATA |awk '{print $16}';;
  used)  
    grep -w "$ZBX_REQ_DATA_TAB" $SOURCE_DATA |awk '{print $10}';;
  autopercent) 
    grep -w "$ZBX_REQ_DATA_TAB" $SOURCE_DATA | awk '{print $NF}' ;;
  type)
    grep -w "$ZBX_REQ_DATA_TAB" $SOURCE_DATA | awk '{print $7}';;
  actualsize) 
    grep -w "$ZBX_REQ_DATA_TAB" $SOURCE_DATA | awk '{print $13}' ;;
  freespace) 
    grep -w "$ZBX_REQ_DATA_TAB" $SOURCE_DATA | awk '{print $19}' ;;
  space) 
    grep -w "$ZBX_REQ_DATA_TAB" $SOURCE_DATA | awk '{print $22}' ;;
  *)
    echo $ERROR_WRONG_PARAM; exit 1;;
esac
exit 0
