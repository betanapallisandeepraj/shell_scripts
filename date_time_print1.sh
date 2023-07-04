#!/bin/bash
bold=$(tput bold)
underline=$(tput smul)
italic=$(tput sitm)
info=$(tput setaf 2)
error=$(tput setaf 160)
warn=$(tput setaf 214)
reset=$(tput sgr0)

touch /tmp/debug_log
print_with_time() {
	var=$(date +[%Y-%m-%d_%H:%M:%S.%N]-\>)
	if [[ "$1" == "-n" ]]; then
		echo -n "${bold}$2${reset}"
		echo -n "${bold}$2${reset}" >> /tmp/debug_log
	else
		echo "${bold}$var${reset} ${info}INFO${reset}:${bold}$1${reset}"
		echo "${bold}$var${reset} ${info}INFO${reset}:${bold}$1${reset}" >> /tmp/debug_log
	fi
}
print_with_time "This file is $(echo $0 | awk -F / '{print $2}'), argv1=$1"
print_with_time "Starting the calibration script"
print_with_time -n "Chan"
print_with_time -n "	0"
print_with_time -n "	1"
