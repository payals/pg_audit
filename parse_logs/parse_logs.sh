#! /bin/bash

# Run this in the system_monitoring logs directory

# writes:

echo "date"$'\t'"wKBps" > writes-sdb.tsv
cat iostat-*.log | grep sdb | awk {'print $2"\t"$11'} >> writes-sdb.tsv

# Locks:

cut -f1,15 pg_locks-*.log | sort | uniq -c > locktest
cat locktest | grep -v mode > locktest1
cat locktest1 | awk {'print $1"\t"$3"\t"$5'} >> locktest2

echo "date"$'\t'"accessShareLock" > AccessShareLock.tsv
cat locktest2 | grep 'AccessShareLock' | awk {'print $2"\t"$1'} > AccessShareLock.tsv

echo "date"$'\t'"RowExclusiveLock" > RowExclusiveLock.tsv
cat locktest2 | grep 'RowExclusiveLock' | awk {'print $2"\t"$1'} > RowExclusiveLock.tsv

echo "date"$'\t'"ShareLock" > ShareLock.tsv
cat locktest2 | grep 'ShareLock' | grep -v 'AccessShareLock' | awk {'print $2"\t"$1'} > ShareLock.tsv

join -a1 -a2 -1 1 -2 1 -o 0 1.2 2.2 -e "0" AccessShareLock.tsv ShareLock.tsv | awk {'print $1"\t"$2"\t"$3'} > joinTest.tsv

echo "date"$'\t'"ExclusiveLock" > ExclusiveLock.tsv
cat locktest2 | grep 'ExclusiveLock' | grep -v 'RowExclusiveLockLock' | awk {'print $2"\t"$1'} >> ExclusiveLock.tsv

join -a1 -a2 -1 1 -2 1 -o 0 1.2 1.3 2.2 -e "0" joinTest.tsv ExclusiveLock.tsv | awk {'print $1"\t"$2"\t"$3"\t"$4'} > joinTest2.tsv
join -a1 -a2 -1 1 -2 1 -o 0 1.2 1.3 1.4 2.2 -e "0" joinTest2.tsv RowExclusiveLock.tsv | awk {'print $1"\t"$2"\t"$3"\t"$4"\t"$5'} > joinTest3.tsv

# Locks Waiting

cut -f1,15,16 pg_locks-*.log | sort | uniq -c | awk '$6 == "f" {print $1"\t"$3"\t"$5"\t"$6}' | awk {'print $3"\t"$1"\t"$2'} > waitlocks.tsv 

# Reads

echo "date"$'\t'"rKBps" > reads-sdb.tsv
cat iostat-*.log | grep sdb |awk {'print $2"\t"$10'} >> reads-sdb.tsv

# Response Time and Wait(iostat)

echo "date"$'\t'"wait"$'\t'"svctm" > response-dm4.tsvctm
cat iostat-*.log | grep dm-4 |awk {'print $2"\t"$14"\t"$15'} >> response-dm4.tsvctm

# CPU Usage

echo "date"$'\t'"usr"$'\t'"sys"$'\t'"iowait" > cpu.tsv 
cat mpstat-*.log | awk {'print $2"\t"$8"\t"$10"\t"$11'} | grep -v 'Linux\|usr\|CPU' | awk 'BEGIN {FS="\t"} $2!="" {print}' >> cpu.tsv

# Memory Used

cat mem-*.log | grep 'MemFree\|MemTotal\|Buffers\|Cached' | grep -v Swap | sed 'h;s/.*//;N;G;s/\n//g' | sed 'h;s/.*//;N;G;s/\n//g' > tempfile
cat tempfile | awk {'print $2"\t"($24-$18-$12-$6)'} >> mem.tsv 
cp mem.tsv memMB.tsv 
cp mem.tsv memGB.tsv 
awk '{ tmp=($2)/(1024) ; printf"%0.2f\n", tmp }' memMB.tsv 
awk '{ tmp=($2)/(1024*1024) ; printf"%0.2f\n", tmp }' memGB.tsv

# Connections

echo "date"$'\t'"count" > connections.tsv 
cat pg_stat_activity-*.log | awk {'print $2'} | sort | uniq -c | awk {'print $2"\t"$1'} >> connections.tsv 
