#!/bin/bash

bold=$(tput bold)
underline=$(tput smul)
italic=$(tput sitm)
info=$(tput setaf 2)
error=$(tput setaf 160)
warn=$(tput setaf 214)
reset=$(tput sgr0)

print_with_time() {
	var=$(date +[%Y-%m-%d_%H:%M:%S.%N]-\>)
	echo "${bold}$var${reset} ${info}INFO${reset}:${bold}$1${reset}"
	echo "${bold}$var${reset} ${info}INFO${reset}:${bold}$1${reset}" >> /tmp/debug_log
}
print_duration() {
	duration=$(($2-$1))
	message=$3
	var=$(echo "$(($duration/3600)) hours:$(($duration/60)) minutes:$(($duration%60)) seconds")
	print_with_time "$message = $var"
}
t1=$(date +%s);
sleep 2; # Your stuff
t2=$(date +%s);
print_duration $t1 $t2 "time taken for this event"
