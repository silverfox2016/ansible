#!/bin/sh
source ~/.bash_profile
connection="system/Pmph\_k28n3 as sysdba"
echo "连接字符串:${connection}"
echo "--------begin------------"

sqlplus $connection @/home/oracle/task/zabbixXJ.sql
echo "--------end------------ "
exit;
