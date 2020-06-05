#/bin/bash
#environment variable
#cpu
notify_url="https://api.telegram.org/bot901901887:AAFEGjmfr6Lk0YK4GrzQXKQd8B6O0aK5wFs/sendMessage"
chats_id="-360758147"
up_time=`uptime|awk '{print $12}'|sed 's/,//'`
cpufuzai="2"
HOSTIP=`curl -s ifconfig.me`
max=70
if [ `echo "$up_time > $cpufuzai"|bc` -eq 1 ];then

mail_sub=`echo -e "【cpu检测报警】 \n\n" "等级；★★★★★ \n\n" "\U0001F976""\U0001F976" "\U0001F976\n" "TIME:$(date +%F_%T)
HOSTNAME:$HOSTNAME
IPADDR:${HOSTIP}
MSG:CPU负载过高！负载为：${up_time}"`
curl -X POST ${notify_url} -d "chat_id="${chats_id}"&text=${mail_sub}" &> /dev/null
fi
cpu_us=`vmstat | awk '{print $13}' | sed -n '$p'`
cpu_sy=`vmstat | awk '{print $14}' | sed -n '$p'`
cpu_id=`vmstat | awk '{print $15}' | sed -n '$p'`
cpu_sum=$(($cpu_us+$cpu_sy))
if [ $cpu_sum -gt ${max} ]
then
	mail_sub=`echo -e "【cpu检测报警】 \n\n" "等级；★★★★★ \n\n" "\U0001F976""\U0001F976" "\U0001F976\n" "TIME:$(date +%F_%T)
HOSTNAME:$HOSTNAME
IPADDR:${HOSTIP}
MSG:CPU使用率过高！已经用了${cpu_sum}%"`
curl -X POST ${notify_url} -d "chat_id="${chats_id}"&text=${mail_sub}" &> /dev/null
fi
