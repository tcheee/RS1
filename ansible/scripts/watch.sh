#!/bin/bash  
if [ -f ./old_crontab ]; then
		if [ -n "$(diff /etc/crontab ./old_crontab)" ]; then
				 echo "Warning, crontab edited!" | mail -s "Crontab edited!" root
		fi;
fi;
cp /etc/crontab ./old_crontab
