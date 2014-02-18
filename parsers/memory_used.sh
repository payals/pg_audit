#!/usr/bin/bash

# $1 logs location
# $2 location to store parsed files

set -x
set -e

cat $1/mem-*.log | grep 'MemFree\|MemTotal\|Buffers\|Cached' | grep -v Swap | sed 'h;s/.*//;N;G;s/\n//g' | sed 'h;s/.*//;N;G;s/\n//g' > $2/tempfile

mf=$(cat $2/tempfile | sed -e "s/\s\{1,\}/ /g" | grep MemFree | awk '{len=split($0, a, " "); for(i=1;i<=len;i++){if (a[i] == "MemFree:") print ++i;}}' | head -1)
mt=$(cat $2/tempfile | sed -e "s/\s\{1,\}/ /g" | grep MemTotal | awk '{len=split($0, a, " "); for(i=1;i<=len;i++){if (a[i] == "MemTotal:") print ++i;}}' | head -1)
b=$(cat $2/tempfile | sed -e "s/\s\{1,\}/ /g" | grep Buffers | awk '{len=split($0, a, " "); for(i=1;i<=len;i++){if (a[i] == "Buffers:") print ++i;}}' | head -1)
c=$(cat $2/tempfile | sed -e "s/\s\{1,\}/ /g" | grep Cached | awk '{len=split($0, a, " "); for(i=1;i<=len;i++){if (a[i] == "Cached:") print ++i;}}' | head -1)

cat $2/tempfile | awk -v mf=$mf -v mt=$mt -v b=$b -v c=$c '{print $2"\t"($mt-$mf-$b-$c)}' > $2/mem_used.tsv 

awk '{ tmp=($2)/(1024) ; printf$1"\t%0.2f\n", tmp }' $2/mem_used.tsv > $2/mem_used_MB.tsv
awk '{ tmp=($2)/(1024*1024) ; printf $1"\t%0.2f\n", tmp }' $2/mem_used.tsv > $2/mem_used_GB.tsv

sed -i "1s/^/date\tmem_used\n&/" $2/mem_used.tsv
sed -i "1s/^/date\tmem_used_MB\n&/" $2/mem_used_MB.tsv
sed -i "1s/^/date\tmem_used_GB\n&/" $2/mem_used_GB.tsv
