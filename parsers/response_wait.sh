#!/usr/bin/bash

# $1 disk name
# $2 response column name
# $3 wait column name

set -x
set -e

response=$(cat iostat-*.log | sed -e "s/\s\{1,\}/ /g" | grep $2 | awk -v var=$2 '{len=split($0, a, " "); for(i=1;i<=len;i++){if (a[i] == var) print i;}}' | head -1)
wait=$(cat iostat-*.log | sed -e "s/\s\{1,\}/ /g" | grep $2 | awk -v var=$3 '{len=split($0, a, " "); for(i=1;i<=len;i++){if (a[i] == var) print i;}}' | head -1)
cat iostat-*.log | grep $1 | awk -v response=$response -v wait=$wait  '{print $2"\t"$response"\t"$wait}'> response-wait-$1.tsv
sed -i "1s/^/date\t$2\t$3\n&/" response-wait-$1.tsv