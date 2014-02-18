#!/usr/bin/bash

# $1 logs location
# $2 location to store parsed files
# $3 usr column name
# $4 sys column name
# $5 iowait column name

set -x
set -e

usr=$(cat $1/mpstat-*.log | sed -e "s/\s\{1,\}/ /g" | grep $3 | awk -v var=$3 '{len=split($0, a, " "); for(i=1;i<=len;i++){if (a[i] == var) print i;}}' | head -1)
sys=$(cat $1/mpstat-*.log | sed -e "s/\s\{1,\}/ /g" | grep $4 | awk -v var=$4 '{len=split($0, a, " "); for(i=1;i<=len;i++){if (a[i] == var) print i;}}' | head -1)
iowait=$(cat $1/mpstat-*.log | sed -e "s/\s\{1,\}/ /g" | grep $5 | awk -v var=$5 '{len=split($0, a, " "); for(i=1;i<=len;i++){if (a[i] == var) print i;}}' | head -1)
#cat mpstat-*.log | grep -v 'Linux\|usr\|CPU' | awk -v usr=$usr -v sys=$sys -v iowait=$iowait  '{print $2"\t"$usr"\t"$sys"\t"$iowait}' | awk 'BEGIN {FS="\t"} $2!="" {print}' > $1_cpu_usage.tsv
cat $1/mpstat-*.log | awk {'print $2"\t"$8"\t"$10"\t"$11'} | grep -v 'Linux\|usr\|CPU' | awk 'BEGIN {FS="\t"} $2!="" {print}' > $2/cpu_usage.tsv
sed -i "1s/^/date\t$3\t$4\t$5\n&/" $2/cpu_usage.tsv