#!/bin/bash 

sites="6af48c dlirzc00"

for site in $(echo $sites)
do
	wget --quiet -O edtmp.json http://$site.ethosdistro.com/?json=yes
	rigs=$(cat edtmp.json |jshon -e rigs -k)
	for rig in $(echo $rigs)
	do
		condition=$(cat edtmp.json |jshon -e rigs -e $rig -e condition|sed s'/"//g')
		gpus=$(cat edtmp.json |jshon -e rigs -e $rig -e gpus|sed s'/"//g')
		miner_instance=$(cat edtmp.json |jshon -e rigs -e $rig -e miner_instance|sed s'/"//g')
		rack_loc=$(cat edtmp.json |jshon -e rigs -e $rig -e rack_loc|sed s'/"//g')
		if [ "$condition" != "mining" ] && [ "$condition" != "throttle" ]
		then
			echo $site/$rack_loc,$miner_instance/$gpus/$condition|mail -s $site '6786306112@vtext.com'
			#echo $site/$rack_loc,$miner_instance/$gpus/$condition
			logger $site/$rack_loc,$miner_instance/$gpus/$condition
		fi

	done
done
	rm edtmp.json
