#!/usr/bin/bash

set -x
set -e

cat pg_stat_activity-*.log | awk {'print $2'} | sort | uniq -c | awk {'print $2"\t"$1'} > connections.tsv 
sed -i "1s/^/date\tcount\n&/" connections.tsv