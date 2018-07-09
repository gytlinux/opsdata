#!/bin/bash
#CPU usage rate and memory

#CPU:
cls1=$(sed -n '1p' /proc/stat | awk '{print $2" "$3" "$4" "$5" "$6" "$7" "$8}')
idle1=$(echo $cls1 | awk '{print $4}')
total1=$(echo $cls1 | awk '{print $1+$2+$3+$4+$5+$6+$7}')

sleep 1

cls2=$(sed -n "1p" /proc/stat | awk '{print $2" "$3" "$4" "$5" "$6" "$7" "$8}')
idle2=$(echo $cls2 | awk '{print $4}')
total2=$(echo $cls2 | awk '{print $1+$2+$3+$4+$5+$6+$7}')

idle=$(awk "BEGIN{print $idle2-$idle1}")
total=$(awk "BEGIN{print $total2-$total1}")
usage=$(awk "BEGIN{print $idle/$total*100 }")
rate=$(awk "BEGIN{print int(100-$usage+0.5)}")

echo $rate


#MEM:
mem=$(cat /proc/meminfo |awk '{print $2}'|tr -s "\n" " ")
usage=$(echo $mem | awk '{print int(($1-$3)/$1*100+0.5)}')
echo $usage
