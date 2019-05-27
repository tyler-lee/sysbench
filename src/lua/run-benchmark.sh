#!/bin/bash

#table_size=$1
#tables=$2
#threads=$3
#time=$4
#cmd_script=$5
#cmd=$6
db=sbtest_origin_oltp
cmd_script=oltp_read_write
table_size="--table_size=100000"
tables="--tables=24"
time="--time=600"
max_threads=96	# pg server max threads is 97

pushd `dirname $0`
mkdir -p ~/results/$db

# Prepare data
cmd=prepare
threads="--threads=$max_threads"
sysbench  --db-driver=pgsql $table_size $tables $threads --report-interval=2 $time --pgsql-host=localhost --pgsql-port=5432 --pgsql-user=sbtest --pgsql-password=password --pgsql-db=$db --auto_inc=off $cmd_script.lua $cmd


# Benchmark data
cmd=run
for ((i = 1; i <= max_threads; i += 1))
do
	threads="--threads=$i"
	echo "Benchmark using origin sysbench $cmd_script on $db with $threads"
	sysbench  --db-driver=pgsql $table_size $tables $threads --report-interval=2 $time --pgsql-host=localhost --pgsql-port=5432 --pgsql-user=sbtest --pgsql-password=password --pgsql-db=$db --auto_inc=off $cmd_script.lua $cmd > ~/results/$db/${cmd_script}_${tables}_${table_size}_${threads}.result
done


# Cleanup data
cmd=cleanup
threads="--threads=$max_threads"
sysbench  --db-driver=pgsql $table_size $tables $threads --report-interval=2 $time --pgsql-host=localhost --pgsql-port=5432 --pgsql-user=sbtest --pgsql-password=password --pgsql-db=$db --auto_inc=off $cmd_script.lua $cmd


popd

