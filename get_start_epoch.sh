#!/bin/sh
#get start epoch 
day=3
epoch=$[ $day*24*60*2 ]
#echo $epoch

head=`curl -s -X POST  -H "Content-Type: application/json" --data '{ "jsonrpc": "2.0", "method": "Filecoin.ChainHead", "params": [], "id": 3 }' 'http://127.0.0.1:1234/rpc/v0' | jq .result.Height`

start_epoch=$[ ${head}+${epoch} ]
echo $start_epoch
