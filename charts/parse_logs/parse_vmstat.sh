#!usr/bin/bash
set -e 
set -x 

parent_dir=/data/logs/system_monitoring
web_dir=/www/htdocs/graphs/data
date=/usr/gnu/bin/date

# Get latest year directory
year=$($date --date='today' +%Y)
cd $parent_dir/$year

# Get latest month directory
month=$($date --date='today' +%m)
cd $month

# Get latest date directory
day=$($date --date='today' +%d)
cd $day

# Get second last iostat file, since last one might be the current hour and hence incomplete.
current_file=$(ls -t1  | grep 'vmstat*' | head -n2 | tail -1)

# Set name of csv file
csv_file=$web_dir/vmstat.csv

# parse contents to csv file
cat $current_file | head -20 | grep 'swap' |awk {'print $5","$6","$7","$8","$9","$10","$11","$23","$24'} > $csv_file
cat $current_file | grep -v 'swap' | grep -v 'kthr' |awk {'print $5","$6","$7","$8","$9","$10","$11","$23","$24'} >> $csv_file
