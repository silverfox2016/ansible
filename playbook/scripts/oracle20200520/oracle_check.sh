#!/bin/bash
EQ_DATA="$2"
ZBX_REQ_DATA_TAB="$1"
SOURCE_DATA=/home/oracle/tablespace.log
case $2 in
  maxmb)       
    grep -w "$ZBX_REQ_DATA_TAB" $SOURCE_DATA |awk '{print $5*1024*1024}';;
  used)  
    grep -w "$ZBX_REQ_DATA_TAB" $SOURCE_DATA |awk '{print $6*1024*1024}';;
  autopercent) 
    grep -w "$ZBX_REQ_DATA_TAB" $SOURCE_DATA |awk '{print $7}';;
  *)
    echo $ERROR_WRONG_PARAM; exit 1;;
esac
exit 0
