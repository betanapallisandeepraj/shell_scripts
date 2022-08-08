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
	echo "${bold}$var${reset} ${info}INFO${reset}:${bold}$1${reset}"
	echo "${bold}$var${reset} ${info}INFO${reset}:${bold}$1${reset}" >> /tmp/debug_log
}
print_with_time "This file is $(echo $0 | awk -F / '{print $2}'), argv1=$1"
print_with_time "Starting the calibration script"
