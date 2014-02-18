#!/usr/bin/bash

# $1 logs location
# $2 location to store parsed files
# $3 disk name
# $4 response column name
# $5 wait column name

set -x
set -e

response=$(cat $1/iostat-*.log | sed -e "s/\s\{1,\}/ /g" | grep $4 | awk -v var=$4 '{len=split($0, a, " "); for(i=1;i<=len;i++){if (a[i] == var) print i;}}' | head -1)
wait=$(cat $1/iostat-*.log | sed -e "s/\s\{1,\}/ /g" | grep $5 | awk -v var=$5 '{len=split($0, a, " "); for(i=1;i<=len;i++){if (a[i] == var) print i;}}' | head -1)
cat $1/iostat-*.log | grep $3 | awk -v response=$response -v wait=$wait  '{print $2"\t"$response"\t"$wait}'> $2/response-wait-$3.tsv
sed -i "1s/^/date\t$4\t$5\n&/" $2/response-wait-$3.tsv