#!/bin/sh
#########################################################################
# Author: billczhang
# Created Time: Tue 05 Jan 2021 05:45:43 PM CST
# File Name: 
# Description: filter miner 
#########################################################################
#set -x
cat miner.dat|while read line
do
	result=`timeout 5 lotus client query-ask ${line}`
	miner=$line
	store_price=`echo $result|awk '{print $6}'`
	verify_price=`echo $result|awk '{print $12}'`
	max_size=`echo $result|awk '{print $17""$18}'`
	#判断max_size是否合适,judege max size
	if [ "${max_size}" != "32GiB" ]
	then
		continue
	fi

	#judge max price
	max_price=0.0000000005 #max price we could accept
	judge_price=`echo "${store_price}<=${max_price}"|bc`
	if [ $judge_price -ne 1 ]
	then
		continue
	fi		
	
	echo $miner
done
