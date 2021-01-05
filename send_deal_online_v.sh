#!/bin/sh
if [ $# -ne 5 ]
then
	echo "please input piece_cid, piece_size, data_cid, data_size, miner"
	exit
fi

piece_cid=$1
piece_size=$2
data_cid=$3
data_size=$4
miner=$5

#获得miner的竞价
#echo "query ask start:", `date`
result=`lotus client query-ask ${miner}`
#echo "query ask end:", `date`

store_price=`echo $result|awk '{print $6}'`
verify_price=`echo $result|awk '{print $12}'`
max_size=`echo $result|awk '{print $17""$18}'`


#echo "miner info: " $miner $store_price $verify_price $max_size

#判断max_size是否合适
if [ "${max_size}" != "32GiB" ]
then
	echo "ERROR, max size is too low"
	exit
fi

#判断价格
max_price=0.0000000005
judge_price=`echo "${verify_price}<=${max_price}"|bc`
#echo ${judge_price}
if [ $judge_price -ne 1 ]
then
	echo "ERROR, price is too high"
	exit
fi

#计算价格
price_rate=`echo "scale=4;${data_size}/1073741824"|bc`
#echo ${price_rate}

price=`echo "scale=20;${price_rate}*${verify_price}"|bc`
real_price="0"${price} #一个区块的存储价格
#echo "price one block" ${real_price}

#发送离线交易
start_epoch=`./get_start_epoch.sh`
#echo "send deal start:", `date`
lotus client deal  --start-epoch ${start_epoch} ${data_cid} ${miner} ${real_price} 1051800 
#echo "send deal end:", `date` "---------------------------------------------\n"
