#!/usr/bin/bash

# $1 file name
# $2 usr column name
# $3 sys column name
# $4 iowait column name

set -x
set -e

usr=$(cat mpstat-*.log | sed -e "s/\s\{1,\}/ /g" | grep $2 | awk -v var=$2 '{len=split($0, a, " "); for(i=1;i<=len;i++){if (a[i] == var) print i;}}' | head -1)
sys=$(cat mpstat-*.log | sed -e "s/\s\{1,\}/ /g" | grep $3 | awk -v var=$3 '{len=split($0, a, " "); for(i=1;i<=len;i++){if (a[i] == var) print i;}}' | head -1)
iowait=$(cat mpstat-*.log | sed -e "s/\s\{1,\}/ /g" | grep $4 | awk -v var=$4 '{len=split($0, a, " "); for(i=1;i<=len;i++){if (a[i] == var) print i;}}' | head -1)
#cat mpstat-*.log | grep -v 'Linux\|usr\|CPU' | awk -v usr=$usr -v sys=$sys -v iowait=$iowait  '{print $2"\t"$usr"\t"$sys"\t"$iowait}' | awk 'BEGIN {FS="\t"} $2!="" {print}' > $1_cpu_usage.tsv
cat mpstat-*.log | awk {'print $2"\t"$8"\t"$10"\t"$11'} | grep -v 'Linux\|usr\|CPU' | awk 'BEGIN {FS="\t"} $2!="" {print}' >> $1_cpu_usage.tsv
sed -i "1s/^/date\t$2\t$3\t$4\n&/" $1_cpu_usage.tsv