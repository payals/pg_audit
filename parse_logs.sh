# !/usr/bin/bash

########## CONFIG ###########

# PATHS
logs_path="/var/www/htdocs/test/data/14"
output_path="/var/www/htdocs/test/data"
parsers_path="./parsers"

# Reads
read_disk="sda"
read_column="rkB/s"

# Writes
write_disk="sda"
write_column="wkB/s"

# Response Time and Service Time
disk="sda"
res_col="await"
svc_col="svctm"

# CPU Usage
usr_col="%usr"
sys_col="%sys"
wait_col="%iowait"

########## CONFIG ###########


usage() {
    cat <<EOF
$0: [-cumlrwi] 
	-c		connections
	-u		cpu usage
	-m		memory used
	-l		locks
	-r		reads
	-w		writes
	-i		response and service times
EOF
}

read_params() {
    while getopts 'cumlrwi' opt "$@"
    do
        case "$opt" in
	    c)
		connections_LG
		;;
            u)
                cpu_usage_LG
                ;;
            m)
                memory_used_LG
                ;;
            l)
                locks_LG
                ;;
            r)
                reads_LG
                ;;
            w)
                writes_LG
                ;;
            i)
                res_svc_LG
                ;;
            h)
                usage
                exit 2
                ;;
            :)
                echo "Option -%s requires argument" "$OPTARG"
                usage
                exit 2
                ;;
            \?)
                if [[ "$OPTARG" == "?" ]]
                then
                    usage
                    exit 2
                fi
                echo "Unknown option -%s" "$OPTARG"
                usage
                exit 2
                ;;
        esac
    done
}

connections_LG() {
    $parsers_path/connection_count.sh $logs_path $output_path
}

cpu_usage_LG() {
    $parsers_path/cpu_usage.sh $logs_path $output_path $usr_col $sys_col $wait_col
}

memory_used_LG() {
    $parsers_path/memory_used.sh $logs_path $output_path
}

locks_LG() {
    $parsers_path/locks.sh $logs_path $output_path
}

reads_LG() {
    $parsers_path/reads_writes.sh $logs_path $output_path $read_disk $read_column
}

writes_LG() {
    $parsers_path/reads_writes.sh $logs_path $output_path $write_disk $write_column
}

res_svc_LG() {
    $parsers_path/response_wait.sh $logs_path $output_path $disk $res_col $svc_col
}

read_params "$@"