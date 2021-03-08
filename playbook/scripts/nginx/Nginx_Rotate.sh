#/bin/bash
#Description: Rotate the Nginx logs to prevent a single logfile from consuming too much disk space.
#AUTHOR: silverfox
#DATE:   2020-11-02
#MAIL:   77042631@qq.com
#VERSION 3.0

#define variables
NGINX_BIN=$(ps -ef | awk '$0~"nginx.*master"&&$0!~"awk" {print $11}')
NGINX_CONF=$(ps -ef |grep nginx |awk '/master/ {print $NF}')
ACCESS_LOG=$(awk '/access_log/ {print $2}' "${NGINX_CONF}")
ERROR_LOG=$(awk '/^[^#].*error.log;/{gsub(/;/, "");print $2}' "${NGINX_CONF}")
DATATIME=$(date -d "yesterday" +%Y-%m-%d)
IPADDR=$(hostname -I |awk '{print $1}')
LOGS_BAK_PATH=/opt/nginx_logs
LOGS_BAK_REMOTE_PATH=/logBakServer/Mooc_muke_logs/${IPADDR}_nginx

# BEGIN Script

if [ ! -d "${LOGS_BAK_PATH}" ];then
        mkdir -p ${LOGS_BAK_PATH}
else
        continue
fi
mv ${ACCESS_LOG} ${LOGS_BAK_PATH}/access.${DATATIME}.log
mv ${ERROR_LOG} ${LOGS_BAK_PATH}/error.${DATATIME}.log
${NGINX_BIN} -s reopen

if [ ! -d "$LOGS_BAK_REMOTE_PATH" ];then
        mkdir -p ${LOGS_BAK_REMOTE_PATH}
else
        continue
fi
tar zcvPf ${LOGS_BAK_REMOTE_PATH}/access.${DATATIME}.log.tgz ${LOGS_BAK_PATH}/access.${DATATIME}.log
tar zcvPf ${LOGS_BAK_REMOTE_PATH}/error.${DATATIME}.log.tgz ${LOGS_BAK_PATH}/error.${DATATIME}.log
find ${LOGS_BAK_PATH} -mtime +180 -type f -name '*.log' -delete
