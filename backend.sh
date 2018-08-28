#! /bin/bash

oids=("${@:2}")
unbuffer perl /tmp/A2/prober $1 $2 -1 ${@:3} | while read result;do

t=`echo $result | cut -d"|" -f1 | perl -pe 'chomp' | tr -d '[:space:]'`
v=000000000
Time=$t$v
IFS='|' read -ra differ <<< "$result"
for ((i=1;i<${#differ[@]};i++))
do
	f=`echo ${differ[$i]} | tr -d '[:space:]'`
	printf "rate,oid=${oids[$i]} value=$f $Time\n" >> moni.txt
done
curl -i -XPOST 'http://localhost:8086/write?db=A3' -u ats:atslabb00 --data-binary @moni.txt

rm moni.txt
done




