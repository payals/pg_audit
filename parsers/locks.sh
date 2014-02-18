#!/usr/bin/bash

# $1 logs location
# $2 location to store parsed files

set -e
set -x 

cut -f1,15 $1/pg_locks-*.log | sort | uniq -c | grep -v mode | awk {'print $3"\t"$1"\t"$5'} > $2/AllLocks.tsv

cat $2/AllLocks.tsv | grep 'AccessShareLock' | awk {'print $1"\t"$2'} > $2/AccessShareLock.tsv

cat $2/AllLocks.tsv | grep 'RowExclusiveLock' | awk {'print $1"\t"$2'} > $2/RowExclusiveLock.tsv

cat $2/AllLocks.tsv | grep 'ShareLock' | grep -v 'AccessShareLock' | awk {'print $1"\t"$2'} > $2/ShareLock.tsv

cat $2/AllLocks.tsv | grep 'ExclusiveLock' | grep -v 'RowExclusiveLock' | awk {'print $1"\t"$2'} > $2/ExclusiveLock.tsv

join -a1 -a2 -1 1 -2 1 -o 0 1.2 2.2 -e "0" $2/AccessShareLock.tsv $2/ShareLock.tsv | awk {'print $1"\t"$2"\t"$3'} > $2/AllShareLocks.tsv

#join -a1 -a2 -1 1 -2 1 -o 0 1.2 1.3 2.2 -e "0" joinTest.tsv ExclusiveLock.tsv | awk {'print $1"\t"$2"\t"$3"\t"$4'} | sort | uniq > joinTest2.tsv
join  -a1 -a2 -1 1 -2 1 -o 0 1.2 2.2 -e "0" $2/RowExclusiveLock.tsv $2/ExclusiveLock.tsv |  awk {'print $1"\t"$2"\t"$3'} > $2/AllExclusiveLocks.tsv

sed -i '1s/^/date\taccessShareLock\n&/' $2/AccessShareLock.tsv
sed -i '1s/^/date\tshareLock\n&/' $2/ShareLock.tsv
sed -i '1s/^/date\trowExclusiveLock\n&/' $2/RowExclusiveLock.tsv
sed -i '1s/^/date\texclusiveLock\n&/' $2/ExclusiveLock.tsv
sed -i '1s/^/date\trowExclusiveLock\texclusiveLock\n&/' $2/AllExclusiveLocks.tsv
sed -i '1s/^/date\taccessShareLock\tshareLock\n&/' $2/AllShareLocks.tsv

# Waiting

cut -f1,15,16 $1/pg_locks-*.log | grep -v mode | grep ShareLock | sort | uniq -c | awk '$6 == "f" {print $3"\t"$1}' > $2/SLTemp.tsv
cut -f1,15,16 $1/pg_locks-*.log | grep -v mode | grep AccessShareLock | sort | uniq -c | awk '$6 == "f" {print $3"\t"$1}' > $2/ASLTemp.tsv
cut -f1,15,16 $1/pg_locks-*.log | grep -v mode | grep ExclusiveLock | sort | uniq -c | awk '$6 == "f" {print $3"\t"$1}' > $2/ELTemp.tsv
cut -f1,15,16 $1/pg_locks-*.log | grep -v mode | grep RowExclusiveLock | sort | uniq -c | awk '$6 == "f" {print $3"\t"$1}' > $2/RELTemp.tsv

join -a1 -a2 -1 1 -2 1 -o 0 1.2 2.2 -e "0" $2/ASLTemp.tsv $2/SLTemp.tsv | awk {'print $1"\t"$2"\t"$3'} > $2/SharedWaiting.tsv
join -a1 -a2 -1 1 -2 1 -o 0 1.2 2.2 -e "0" $2/RELTemp.tsv $2/ELTemp.tsv | awk {'print $1"\t"$2"\t"$3'} > $2/ExclusiveWaiting.tsv

sed -i '1s/^/date\taccessShareLock\tshareLock\n&/' $2/SharedWaiting.tsv
sed -i '1s/^/date\trowExclusiveLock\texclusiveLock\n&/' $2/ExclusiveWaiting.tsv