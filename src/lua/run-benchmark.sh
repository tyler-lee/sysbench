#!/bin/bash

pushd `dirname $0`

table_size=100000
tables=24
time=600
max_threads=64	# pg server max threads is 97
db=sbtest_origin_oltp
cmd_script=oltp_read_write

mkdir -p ~/results/$db

# prototype
function __oltp_prototype__() {
	threads=${1:-$max_threads}
	cmd=${2}
	run_cmd="sysbench  --db-driver=pgsql --table_size=$table_size --tables=$tables --threads=$threads --report-interval=2 --time=$time --pgsql-host=localhost --pgsql-port=5432 --pgsql-user=sbtest --pgsql-password=password --pgsql-db=$db --auto_inc=off $cmd_script.lua $cmd"
	$run_cmd
	echo "$run_cmd  --> Done"
	#$run_cmd > ~/results/$db/${cmd_script}_${tables}_${table_size}_${threads}.result
}

__oltp_prototype__ $1 $2


popd

