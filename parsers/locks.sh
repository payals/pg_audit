#!/usr/bin/bash

cut -f1,15 pg_locks-*.log | sort | uniq -c | grep -v mode | awk {'print $3"\t"$1"\t"$5'} > AllLocks.tsv

cat AllLocks.tsv | grep 'AccessShareLock' | awk {'print $1"\t"$2'} > AccessShareLock.tsv

cat AllLocks.tsv | grep 'RowExclusiveLock' | awk {'print $1"\t"$2'} > RowExclusiveLock.tsv

cat AllLocks.tsv | grep 'ShareLock' | grep -v 'AccessShareLock' | awk {'print $1"\t"$2'} > ShareLock.tsv

cat AllLocks.tsv | grep 'ExclusiveLock' | grep -v 'RowExclusiveLock' | awk {'print $1"\t"$2'} > ExclusiveLock.tsv

join -a1 -a2 -1 1 -2 1 -o 0 1.2 2.2 -e "0" AccessShareLock.tsv ShareLock.tsv | awk {'print $1"\t"$2"\t"$3'} > AllShareLocks.tsv

#join -a1 -a2 -1 1 -2 1 -o 0 1.2 1.3 2.2 -e "0" joinTest.tsv ExclusiveLock.tsv | awk {'print $1"\t"$2"\t"$3"\t"$4'} | sort | uniq > joinTest2.tsv
join  -a1 -a2 -1 1 -2 1 -o 0 1.2 2.2 -e "0" RowExclusiveLock.tsv ExclusiveLock.tsv |  awk {'print $1"\t"$2"\t"$3'} > AllExclusiveLocks.tsv

sed -i '1s/^/date\taccessShareLock\n&/' AccessShareLock.tsv
sed -i '1s/^/date\tshareLock\n&/' ShareLock.tsv
sed -i '1s/^/date\trowExclusiveLock\n&/' RowExclusiveLock.tsv
sed -i '1s/^/date\texclusiveLock\n&/' ExclusiveLock.tsv
sed -i '1s/^/date\trowExclusiveLock\texclusiveLock\n&/' AllExclusiveLocks.tsv
sed -i '1s/^/date\taccessShareLock\tshareLock\n&/' AllShareLocks.tsv

# Waiting

cut -f1,15,16 pg_locks-*.log | grep -v mode | grep ShareLock | sort | uniq -c | awk '$6 == "f" {print $3"\t"$1}' > SLTemp.tsv
cut -f1,15,16 pg_locks-*.log | grep -v mode | grep AccessShareLock | sort | uniq -c | awk '$6 == "f" {print $3"\t"$1}' > ASLTemp.tsv
cut -f1,15,16 pg_locks-*.log | grep -v mode | grep ExclusiveLock | sort | uniq -c | awk '$6 == "f" {print $3"\t"$1}' > ELTemp.tsv
cut -f1,15,16 pg_locks-*.log | grep -v mode | grep RowExclusiveLock | sort | uniq -c | awk '$6 == "f" {print $3"\t"$1}' > RELTemp.tsv

join -a1 -a2 -1 1 -2 1 -o 0 1.2 2.2 -e "0" ASLTemp.tsv SLTemp.tsv | awk {'print $1"\t"$2"\t"$3'} > SharedWaiting.tsv
join -a1 -a2 -1 1 -2 1 -o 0 1.2 2.2 -e "0" RELTemp.tsv ELTemp.tsv | awk {'print $1"\t"$2"\t"$3'} > ExclusiveWaiting.tsv