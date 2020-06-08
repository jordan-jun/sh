path = $$PWD
disk:
	echo "*/10 * * * * root $(path)/diskcheck/check-disk.sh >>$(path)/diskcheck/logs/disk-check.log 2>&1 &" >> /etc/crontab
cpu:
	echo "*/10 * * * * root $(path)/cpucheck/cpucheck.sh 1>/dev/null 2>$1" >> /etc/crontab
