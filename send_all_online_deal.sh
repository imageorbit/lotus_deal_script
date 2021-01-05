#!/bin/sh
#set -x
if [ $# -ne 1 ]
then
	echo "please input cid filename"
	exit
fi

filename=$1
miner="f021961"
#miner="f040332"
#miner="f019002"
script_path="/tank1/maris/google_full/"
output_filename=${filename}_${miner}_`date +%Y%m%d_%H%M%S`".dat"

line_num=`cat ${filename}|wc -l`
thread_num=1 #进程数
max_circle=$[ $line_num/${thread_num}+1 ]
for((i=0;i<${max_circle};i++))
do
        line_start=$[ ${i}*${thread_num}+1 ]
        line_end=$[ (${i}+1)*${thread_num} ]
        for line in `sed -n ''${line_start}','${line_end}'p' ${filename}`
        do
  	    {  
		filename=`echo ${line}|awk -F "," '{print $1}'|sed "s#${script_path}##"`
		data_cid=`echo ${line}|awk -F "," '{print $2}'`
		piece_cid=`echo ${line}|awk -F "," '{print $3}'`
		piece_size=`echo ${line}|awk -F "," '{print $4}'`
		data_size=`echo ${line}|awk -F "," '{print $5}'`
		deal_id=`./send_deal_online.sh $piece_cid $piece_size $data_cid $data_size $miner`
		echo $filename","$deal_id >> ${output_filename}
            } &
        done
        wait
done
