#!/usr/bin/env bash

# ---------------------------------------------------------+
#                  CHECK DISK SPACE LEFT                   |
#   Filename: check-disk.sh                                |
#   Desc:                                                  |
#       This script can check disk space left              |
#       Once usage of the disk over the limited            |
#       The script will send a telegram msg                |
#       Deploy it by crontab. e.g. per 15 min              |
#   Usage:                                                 |
#       ./check-disk.sh <percent>                          |
#                                                          |
# ---------------------------------------------------------+

# -------------------------------
#  Set environment here
# ------------------------------

notify_url="https://api.telegram.org/bot901901887:AAFEGjmfr6Lk0YK4GrzQXKQd8B6O0aK5wFs/sendMessage"
chats_id="-360758147"
max=80
alert=n
clear_alert=n
temp_file=/tmp/check-disk.txt

# --------------------------------
#  Start to check the disk space
# --------------------------------
percent=`df -P / | tail -1 | awk '{print $5 }' | cut -d'%' -f1`
if [[ "${percent}" -ge "${max}" ]]; then
    alert=y
fi;

date1=$(date "+%Y-%m-%d %H:%M:%S")

echo "[${date1}] 磁盘使用： ${percent} %"

# ------------------------------------------------------------------------
#  When usage of the disk over the limited then send message with df output
# ------------------------------------------------------------------------
HOSTIP=`curl -s ifconfig.me`

if [[ ! "${alert}" = 'n' ]];then
    # 通知硬盘超过了，并放置一个临时文件
    df -h|grep -v 'docker\|pods'>${temp_file}
    mail_sub=`echo -e "【磁盘预警】 \n\n" "等级；★★★★★ \n\n" "\U0001F976""\U0001F976" "\U0001F976\n" "TIME:$(date +%F_%T)
使用量：${percent}% > ${max}%
公网IP：${HOSTIP}
hostname: ${HOSTNAME}"`
curl -X POST ${notify_url} -d "chat_id="${chats_id}"&text=${mail_sub}" &> /dev/null
elif [[ -f "$temp_file" ]];then
    # 通知硬盘恢复，并删除临时文件
    rm -f ${temp_file}
    mail_sub=`echo -e "【磁盘恢复】 \n\n" "等级；★ \n\n" "\U0001F600""\U0001F600" "\U0001F600\n" "TIME:$(date +%F_%T)
使用量：${percent}% < ${max}%
公网IP：${HOSTIP}
hostname: ${HOSTNAME}"`
curl -X POST ${notify_url} -d "chat_id="${chats_id}"&text=${mail_sub}" &> /dev/null
fi;

exit;
