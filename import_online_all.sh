#!/bin/sh
src_path="/data/maris/google_full/"
pathname="open-images-dataset-train8"
filename=${pathname}".list"
rm ${pathname}".cid"

#输出到文件名
find ${pathname} -name "*.zip" > ${filename}
line_num=`cat ${filename}|wc -l`
thread_num=5 #进程数
max_circle=$[ $line_num/${thread_num}+1 ]
for((i=0;i<${max_circle};i++))
do
        line_start=$[ ${i}*${thread_num}+1 ]
        line_end=$[ (${i}+1)*${thread_num} ]
        for line in `sed -n ''${line_start}','${line_end}'p' ${filename}`
        do
                {
                        echo $line #filename
                        import_info=`lotus client import ${line}`
			data_cid=`echo ${import_info}|awk '{print $4}'`
			#get car file
			#lotus client generate-car ${src_path}${line} ${src_path}${line}".car"
			#get piece cid
			#piece_cid_info=`lotus client commP  ${src_path}${line}".car"`
			#piece_cid=`echo ${piece_cid_info}|awk '{print $2}'`
			#get size
			size_info=`./get_size.py ${line}`
			#output
			echo ${src_path}${line}","${data_cid}","${piece_cid}","${size_info} >> ${pathname}".cid"

                } &
        done
        wait
done

