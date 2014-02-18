#!/usr/bin/bash

# $1 disk name
# $2 column name
# $3 type

set -x
set -e

col=$(echo $2 | sed "s/\//p/g")
echo "date"$'\t'"$col" > $3-$1.tsv
pos=$(cat iostat-*.log | sed -e "s/\s\{1,\}/ /g" | grep $2 | awk -v var=$2 '{len=split($0, a, " "); for(i=1;i<=len;i++){if (a[i] == var) print i;}}' | head -1)
cat iostat-*.log | grep $1 | awk -v position=$pos '{print $2"\t"$position}'>> $3-$1.tsv
