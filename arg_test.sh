#!/bin/bash
build_log="/tmp/build_log"
build_server_dir="$HOME/build_server"
build_code() {
	build_log_var="$build_log""_$1.txt"
	echo $build_log_var
}

var_time=$(date '+%H%M%S%d%m%Y')
build_code $var_time

abc() {
	echo "$build_server_dir/builds/lede_$1"
}
abc $var_time
