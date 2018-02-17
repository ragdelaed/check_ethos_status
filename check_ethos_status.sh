#!/bin/bash

sites="6af48c dlirzc"

for site in $(echo $sites)
do
	echo checking $site
	rm edtmp.json
	wget --quiet -O edtmp.json http://$site.ethosdistro.com/?json=yes
	sleep 1
	total_gpus=$(cat edtmp.json |sed 's/,/\n/g'|grep gpus|grep per|grep total|cut -f 2 -d :)
	live_gpus=$(cat edtmp.json |sed 's/,/\n/g'|grep gpus|grep per|grep live|cut -f 2 -d :)
	if [ "$live_gpus" = "null" ];
	then
		live_gpus=0
	fi

	if [ "$live_gpus" -lt "$total_gpus" ];
	then
		echo 'degraded gpus detected for http://'$site'.ethosdistro.com'|mail -s 'degraded gpus' '6786306112@vtext.com'
	else
		echo good
	fi
done
