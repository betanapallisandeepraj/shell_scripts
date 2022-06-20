################################################################################
# Usage:
# To run all test from 1 to 41
#	$./module_test_host_152001102021.sh
# To run any selected test in 1 to 41
#	$./module_test_host_152001102021.sh <test number>
# Examples:
#	$./module_test_host_152001102021.sh
#	$./module_test_host_152001102021.sh 11
#	$./module_test_host_152001102021.sh 3
#	$./module_test_host_152001102021.sh 03
#################################################################################
#!/bin/ash
runtime_start=$(date +%s.%N)

default_target_ip="10.223.80.106"
client_ip="10.223.62.113"	#make sure client also in same channel and bandwidth, 
default_mode="mesh"
default_channel=7
default_bandwidth=10
default_model="RM-2450-2K-XW"

#rm ~/.ssh/known_hosts
#ssh-keygen -f "~/.ssh/known_hosts" -R $default_target_ip

ssh_silent_cmd="ssh -q -o StrictHostKeyChecking=no root@$default_target_ip"
model=$($ssh_silent_cmd "fes_model.sh get")
echo "Module test begin for $model"



is_wearable=$($ssh_silent_cmd "sr_personality -w")
if [[ $is_wearable == "true" ]]; then
	interface="wlan1"
	echo "wearable device detected."
else
	interface="wlan0"
fi

show_sleep(){
	secs=$(($1))
	while [ $secs -gt 0 ]; do
		echo -ne "$secs\033[0K\r"
		sleep 1
		: $((secs--))
	done
}

# argument1=$1="ip", argument2=$2="wait_time"
# Usage: response_check $default_target_ip "50"
response_check() {
	ip=$1
	wait_time=$2	# waiting time in seconds.
	echo "waiting for maximum of $wait_time seconds until response of $ip:"
	for (( c=1; c<=$wait_time; c++ ))
	do
		resp=$(ping -c 1 -i 1 -w 1 $ip | head -2 | tail -1 | awk '{print $7}' | awk -F = '{print $1}')
		if [[ $resp  != "time" ]]; then
			echo -ne "$c/$wait_time\r"
		else
			time="$c"
			echo -e "response time is approximately $time seconds."
			return 1
		fi
	done
	return 0
}

# argument1=$1="ip", argument2=$2="client_ip", argument3=$3="wait_time"
# Usage: response_check $default_target_ip $client_ip "50"
response_check_client() {
	ip=$1
	cli_ip=$2
	wait_time=$3	# waiting time in seconds.
	response_check $ip $wait_time
	if [[ $?  == 0 ]]; then
		return 0
	fi
	echo "waiting for maximum of $wait_time seconds until response of $cli_ip:"
	for (( c=1; c<=$wait_time; c++ ))
	do
		resp=$(ssh -q -o StrictHostKeyChecking=no root@$ip "ping -c 1 -i 1 -w 1 $cli_ip" | head -2 | tail -1 | awk '{print $7}' | awk -F = '{print $1}')
		if [[ $resp  != "time" ]]; then
			echo -ne "$c/$wait_time\r"
		else
			time="$c"
			echo -e "response time is approximately $time seconds."
			return 1
		fi
	done
	return 0
}

# Function to find presence of a keyword in a webpage
# argument1=$1="page link", argument2=$2="keyword to find"
# Usage: find_keyword "https://$default_target_ip/cgi-bin/luci/" "Status"
find_keyword() {
	get_cookie_cmd="curl -v -k --cookie-jar /tmp/cookies.txt --form luci_password= --form luci_username=root"
	get_page_cmd="curl -v -k -b /tmp/cookies.txt"
	page=$1
	keyword=$2
	echo "Finding keyword=$2 in page=$1"
	$get_cookie_cmd $page
	echo "got cookies for page $page"
	$get_page_cmd $page > /tmp/temp_page.txt
	echo "page downloaded to /tmp/temp_page.txt"
	# grep returns 0 if keyword found, 1 if not found, 2 on error.
	grep $keyword /tmp/temp_page.txt		
	ret=$?
	#cleaning the files
	rm /tmp/cookies.txt /tmp/temp_page.txt
	echo "sending return value $ret"
	if [[ $ret  == 0 ]]; then
		return 1
	else 
		return 0
	fi
}

# Function to check the default mode presence, before starting the test. 
# arguments= no arguments
check_defaults() {
	#echo "checking for mode=$default_mode,channel=$default_channel,bandwidth=$default_bandwidth"
	mode=$($ssh_silent_cmd "iw $interface info" | grep 'type' | awk '{print $2}')
	channel=$($ssh_silent_cmd "iw $interface info" | grep 'channel' | awk '{print $2}')
	bandwidth=$($ssh_silent_cmd "iw $interface info" | grep 'channel' | awk '{print $6}')
	default_br_wan_ip_1=$($ssh_silent_cmd "ifconfig br-wan" | head -n 1 | awk -F : '{print $6}')
	default_br_wan_ip_1=$((16#$default_br_wan_ip_1))
	default_br_wan_ip_2=$($ssh_silent_cmd "ifconfig br-wan" | head -n 1 | awk -F : '{print $7}')
	default_br_wan_ip_2=$((16#$default_br_wan_ip_2 - 1))
	default_br_wan_ip="10.223.$default_br_wan_ip_1.$default_br_wan_ip_2"
	br_wan_ip=$($ssh_silent_cmd "ifconfig br-wan" | head -n 2 | tail -1 | awk -F : '{print $2}' | awk '{print $1}')
	if [[ $mode != $default_mode ]]; then
		echo "Present settings are mode=$mode,channel=$channel,bandwidth=$bandwidth,br_wan_ip=$br_wan_ip"
		echo "Expected settings are mode=$default_mode,channel=$default_channel,bandwidth=$default_bandwidth,br_wan_ip=$default_br_wan_ip"
		return 0
	elif [[ $channel != $default_channel ]]; then
		echo "Present settings are mode=$mode,channel=$channel,bandwidth=$bandwidth,br_wan_ip=$br_wan_ip"
		echo "Expected settings are mode=$default_mode,channel=$default_channel,bandwidth=$default_bandwidth,br_wan_ip=$default_br_wan_ip"
		return 0
	elif [[ $bandwidth != $default_bandwidth ]]; then
		echo "Present settings are mode=$mode,channel=$channel,bandwidth=$bandwidth,br_wan_ip=$br_wan_ip"
		echo "Expected settings are mode=$default_mode,channel=$default_channel,bandwidth=$default_bandwidth,br_wan_ip=$default_br_wan_ip"
		return 0
	elif [[ $br_wan_ip != $default_br_wan_ip ]]; then
		echo "Present settings are mode=$mode,channel=$channel,bandwidth=$bandwidth,br_wan_ip=$br_wan_ip"
		echo "Expected settings are mode=$default_mode,channel=$default_channel,bandwidth=$default_bandwidth,br_wan_ip=$default_br_wan_ip"
		echo "Need to set the target in defult mesh mode and reboot."
		return 0
	else
		return 1
	fi
}

TEST_00001() {
	echo "Starting of $FUNCNAME"
	check_defaults
	if [[ $? == 0 ]]; then
		return 0
	fi
	test_interface=$interface
	var=$($ssh_silent_cmd "ifconfig" | grep $test_interface | awk '{print $1}')
	#echo $var
	echo "End of $FUNCNAME"
	if [[ $test_interface == $var ]]; then
		return 1
	else
		return 0
	fi
}

TEST_00002() {
	echo "Starting of $FUNCNAME"
	check_defaults
	if [[ $? == 0 ]]; then
		return 0
	fi
	test_interface="eth0"
	var=$($ssh_silent_cmd "ifconfig" | grep $test_interface | awk '{print $1}')
	#echo $var
	echo "End of $FUNCNAME"
	if [[ $test_interface == $var ]]; then
		return 1
	else
		return 0
	fi
}

TEST_00003() {
	echo "Starting of $FUNCNAME"
	check_defaults
	if [[ $? == 0 ]]; then
		return 0
	fi
	test_interface="eth1"
	var=$($ssh_silent_cmd "ifconfig" | grep $test_interface | awk '{print $1}')
	#echo $var
	echo "End of $FUNCNAME"
	if [[ $test_interface == $var ]]; then
		return 1
	else
		return 0
	fi
}

TEST_00004() {
	echo "Starting of $FUNCNAME"
	check_defaults
	if [[ $? == 0 ]]; then
		return 0
	fi
	var=$($ssh_silent_cmd "ps | grep mosquitto" | awk '{print $2}')
	#echo $var
	STR=$var
	STR="${STR//$'\n'/ }"
	#echo $STR
	SUB="mosquitt"
	#echo $SUB
	echo "End of $FUNCNAME"
	if echo "$STR" | grep $SUB 1>/dev/null; then
		return 1
	else
		return 0
	fi
}

TEST_00005() {
	echo "Starting of $FUNCNAME"
	check_defaults
	if [[ $? == 0 ]]; then
		return 0
	fi
	var=$($ssh_silent_cmd "ls /usr/bin/socat")
	#echo $var
	STR=$var
	STR="${STR//$'\n'/ }"
	#echo $STR
	SUB="socat"
	#echo $SUB
	echo "End of $FUNCNAME"
	if echo "$STR" | grep $SUB 1>/dev/null; then
		return 1
	else
		return 0
	fi
}

TEST_00006() {
	echo "Starting of $FUNCNAME"
	check_defaults
	if [[ $? == 0 ]]; then
		return 0
	fi
	var=$($ssh_silent_cmd "ls /usr/bin/iperf3")
	#echo $var
	STR=$var
	STR="${STR//$'\n'/ }"
	#echo $STR
	SUB="iperf3"
	#echo $SUB
	echo "End of $FUNCNAME"
	if echo "$STR" | grep $SUB 1>/dev/null; then
		return 1
	else
		return 0
	fi
}

TEST_00007() {
	echo "Starting of $FUNCNAME"
	check_defaults
	if [[ $? == 0 ]]; then
		return 0
	fi
	var=$($ssh_silent_cmd "ls /usr/bin/dl-prism-ctrl")
	#echo $var
	STR=$var
	STR="${STR//$'\n'/ }"
	#echo $STR
	SUB="dl-prism-ctrl"
	#echo $SUB
	echo "End of $FUNCNAME"
	if echo "$STR" | grep $SUB 1>/dev/null; then
		return 1
	else
		return 0
	fi
}

TEST_00008() {
	echo "Starting of $FUNCNAME"
	check_defaults
	if [[ $? == 0 ]]; then
		return 0
	fi
	var=$($ssh_silent_cmd "ls /usr/bin/sr-ctrl-usb")
	#echo $var
	STR=$var
	STR="${STR//$'\n'/ }"
	#echo $STR
	SUB="sr-ctrl-usb"
	#echo $SUB
	echo "End of $FUNCNAME"
	if echo "$STR" | grep $SUB 1>/dev/null; then
		return 1
	else
		return 0
	fi
}

TEST_00009() {
	echo "Starting of $FUNCNAME"
	check_defaults
	if [[ $? == 0 ]]; then
		return 0
	fi
	var=$($ssh_silent_cmd "ls /usr/bin/sysutils")
	#echo $var
	STR=$var
	STR="${STR//$'\n'/ }"
	#echo $STR
	SUB="sysutils"
	#echo $SUB
	echo "End of $FUNCNAME"
	if echo "$STR" | grep $SUB 1>/dev/null; then
		return 1
	else
		return 0
	fi
}

TEST_00010() {
	echo "Starting of $FUNCNAME"
	check_defaults
	if [[ $? == 0 ]]; then
		return 0
	fi
	var=$($ssh_silent_cmd "top -n 1" | awk '{print $7}' | tail -n +5)
	#echo $var
	STR=$var
	STR="${STR//$'\n'/ }"
	#echo $STR
	STR="${STR//$'%'/ }"
	#echo $STR

	echo $STR > /tmp/word_count.txt
	char_count=$(wc -c /tmp/word_count.txt | awk '{print $1}')
	#echo "characters=$char_count"
	new_line_count=$(wc -l /tmp/word_count.txt | awk '{print $1}')
	#echo "newline_characters=$new_line_count"
	word_count=$(wc -w /tmp/word_count.txt | awk '{print $1}')
	#echo "words=$word_count"
	space_count=$((word_count-1))
	#echo "space_count=$space_count"
	temp=$((word_count+space_count+new_line_count))
	#echo $temp
	rm /tmp/word_count.txt
	echo "End of $FUNCNAME"
	if [[ $char_count == $temp ]]; then
		return 1
	else
		return 0
	fi
}

TEST_00011() {
	echo "Starting of $FUNCNAME"
	check_defaults
	if [[ $? == 0 ]]; then
		return 0
	fi
	used_memory=$($ssh_silent_cmd  "free" | awk '{print $3}' | head -2 | tail -n 1)
	#echo $used_memory
	threshold_used_memory="32000"
	#echo $threshold_used_memory
	echo "End of $FUNCNAME"
	if [ "$used_memory" -le "$threshold_used_memory" ]; then
		return 1
	else
		return 0
	fi
	
}

TEST_00012() {
	echo "Starting of $FUNCNAME"
	check_defaults
	if [[ $? == 0 ]]; then
		return 0
	fi
	page1="https://$default_target_ip/cgi-bin/luci/"
	page2="https://$default_target_ip/cgi-bin/luci/admin/status/overview"
	page3="https://$default_target_ip/cgi-bin/luci/mini/network/wireless"
	page4="https://$default_target_ip/cgi-bin/luci/admin/network/wireless"
	page5="https://$default_target_ip/cgi-bin/luci/mini/network/wireless/radio0.network1"
	page6="https://$default_target_ip/cgi-bin/luci/admin/network/wireless/radio0.network1"
	page_1_2_key="Status"
	page_3_4_key="Overview"
	page_5_6_key="Point"
	find_keyword $page1 $page_1_2_key
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "loading $page1 failed"
		return 0
	fi
	find_keyword $page2 $page_1_2_key
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "loading $page2 failed"
		return 0
	fi
	find_keyword $page3 $page_3_4_key
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "loading $page3 failed"
		return 0
	fi
	find_keyword $page4 $page_3_4_key
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "loading $page4 failed"
		return 0
	fi
	find_keyword $page5 $page_5_6_key
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "loading $page5 failed"
		return 0
	fi
	find_keyword $page6 $page_5_6_key
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "loading $page6 failed"
		return 0
	fi
	echo "End of $FUNCNAME"
	return 1
}

TEST_00013() {
	echo "Starting of $FUNCNAME"
	check_defaults
	if [[ $? == 0 ]]; then
		return 0
	fi
	page1="https://$default_target_ip/cgi-bin/luci/"
	page2="https://$default_target_ip/cgi-bin/luci/admin/status/overview"
	page3="https://$default_target_ip/cgi-bin/luci/mini/network/network"
	page4="https://$default_target_ip/cgi-bin/luci/admin/network/network"
	page5="https://$default_target_ip/cgi-bin/luci/mini/network/network/wan"
	page6="https://$default_target_ip/cgi-bin/luci/admin/network/network/wan"
	page_1_2_key="Status"
	page_3_4_key="Interfaces"
	page_5_6_key="WAN"
	find_keyword $page1 $page_1_2_key
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "loading $page1 failed"
		return 0
	fi
	find_keyword $page2 $page_1_2_key
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "loading $page2 failed"
		return 0
	fi
	find_keyword $page3 $page_3_4_key
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "loading $page3 failed"
		return 0
	fi
	find_keyword $page4 $page_3_4_key
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "loading $page4 failed"
		return 0
	fi
	find_keyword $page5 $page_5_6_key
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "loading $page5 failed"
		return 0
	fi
	find_keyword $page6 $page_5_6_key
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "loading $page6 failed"
		return 0
	fi
	echo "End of $FUNCNAME"
	return 1
}

TEST_00014() {
	echo "Starting of $FUNCNAME"
	check_defaults
	if [[ $? == 0 ]]; then
		return 0
	fi
	page1="https://$default_target_ip/cgi-bin/luci/"
	page2="https://$default_target_ip/cgi-bin/luci/admin/status/overview"
	page3="https://$default_target_ip/cgi-bin/luci/mini/network/firewall"
	page4="https://$default_target_ip/cgi-bin/luci/admin/network/firewall"
	page_1_2_key="Status"
	page_3_4_key="Firewall"
	find_keyword $page1 $page_1_2_key
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "loading $page1 failed"
		return 0
	fi
	find_keyword $page2 $page_1_2_key
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "loading $page2 failed"
		return 0
	fi
	find_keyword $page3 $page_3_4_key
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "loading $page3 failed"
		return 0
	fi
	find_keyword $page4 $page_3_4_key
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "loading $page4 failed"
		return 0
	fi
	echo "End of $FUNCNAME"
	return 1
}


TEST_00015() {
	echo "Starting of $FUNCNAME"
	check_defaults
	if [[ $? == 0 ]]; then
		return 0
	fi
	test_channel=9
	#echo $test_channel
	current_channel=$($ssh_silent_cmd "iw $interface info" | awk '{print $2}' | head -7 | tail -n 1)
	#echo $current_channel
	echo "setting to test_channel=$test_channel"
	$ssh_silent_cmd "uci set wireless.radio0.channel=$test_channel"
	$ssh_silent_cmd "uci commit wireless"
	$ssh_silent_cmd "wifi"
	show_sleep 15

	new_channel=$($ssh_silent_cmd "iw $interface info" | awk '{print $2}' | head -7 | tail -n 1)
	#echo $new_channel

	echo "setting to default_channel=$default_channel"
	$ssh_silent_cmd "uci set wireless.radio0.channel=$default_channel"
	$ssh_silent_cmd "uci commit wireless"
	$ssh_silent_cmd "wifi"
	show_sleep 15
	echo "End of $FUNCNAME"
	if [[ $new_channel == $test_channel ]]; then
		return 1
	else
		return 0
	fi
}

TEST_00016() {
	echo "Starting of $FUNCNAME"
	check_defaults
	if [[ $? == 0 ]]; then
		return 0
	fi
	test_bandwidth=5
	#echo $test_bandwidth
	current_bandwidth=$($ssh_silent_cmd "iw $interface info" | awk '{print $6}' | head -7 | tail -n 1)
	#echo $current_bandwidth
	echo "setting to test_bandwidth=$test_bandwidth"
	$ssh_silent_cmd "uci set wireless.radio0.chanbw=$test_bandwidth"
	$ssh_silent_cmd "uci commit wireless"
	$ssh_silent_cmd "wifi"
	show_sleep 15

	new_bandwidth=$($ssh_silent_cmd "iw $interface info" | awk '{print $6}' | head -7 | tail -n 1)
	#echo $new_bandwidth

	if [[ $new_bandwidth == $test_bandwidth ]]; then
			echo "------------------------------------------------------"
			echo -e "\t$FUNCNAME\t\t==>\tPASS"
			echo "------------------------------------------------------"
	else
			echo "------------------------------------------------------"
			echo -e "$FUNCNAME\t\t==>\tFAIL"
			echo "------------------------------------------------------"
	fi
	echo "setting to default_mode=$default_mode"
	$ssh_silent_cmd "/usr/share/simpleconfig/setup.sh $default_mode"
	show_sleep 60
	echo "End of $FUNCNAME"
	if [[ $new_bandwidth == $test_bandwidth ]]; then
		return 1
	else
		return 0
	fi
}

TEST_00017() {
	echo "Starting of $FUNCNAME"
	echo "Note: If it is repeatedly failing due to known host ssh key, "
	echo "go to target console, ssh to client and give yes when prompted to add known hosts"
	check_defaults
	if [[ $? == 0 ]]; then
		return 0
	fi
	response_check_client $default_target_ip $client_ip "10"
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "$client_ip is not responsive"
		return 0
	fi
	channel=15     #Channel 15 is 912MHz
	bandwidth=20   #20MHz
	threshold_bitrate=5     # Mbits/sec
	mode="mesh"
	client_mode="mesh"
	server_ip=$($ssh_silent_cmd "ifconfig br-wan" | awk '{print $2}' | head -n 2 | tail -1 | awk -F : '{print $2}')
	echo "echo \"setting $client_mode mode\"" > /tmp/temp.cmd
	echo "/usr/share/simpleconfig/setup.sh $client_mode" >> /tmp/temp.cmd
	echo "echo \"waiting for 60 seconds\"" >> /tmp/temp.cmd
	echo "sleep 60" >> /tmp/temp.cmd
	echo "echo \"setting $channel channel,bandwidth $bandwidth\"" >> /tmp/temp.cmd
	echo "uci set wireless.radio0.channel=$channel" >> /tmp/temp.cmd
	echo "uci set wireless.radio0.chanbw=$bandwidth" >> /tmp/temp.cmd
	echo "uci commit" >> /tmp/temp.cmd
	echo "wifi" >> /tmp/temp.cmd
	echo "sleep 10" >> /tmp/temp.cmd
	chmod 777 /tmp/temp.cmd
	scp /tmp/temp.cmd root@$default_target_ip:/tmp/
	$ssh_silent_cmd "scp /tmp/temp.cmd root@$client_ip:/tmp/"
	
	response_check_client $default_target_ip $client_ip "10"
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "$client_ip is not responsive"
		return 0
	fi
	
	echo "setting $client_mode mode in $client_ip"
	$ssh_silent_cmd "ssh root@$client_ip "/tmp/temp.cmd" &"	# this will take 70 seconds to execute in background. 
	show_sleep 70
	echo "setting $mode mode in $server_ip"
	$ssh_silent_cmd "/usr/share/simpleconfig/setup.sh $mode" > /dev/null
	show_sleep 60
	$ssh_silent_cmd "uci set wireless.radio0.channel=$channel"
	$ssh_silent_cmd "uci set wireless.radio0.chanbw=$bandwidth"
	$ssh_silent_cmd "uci commit wireless"
	$ssh_silent_cmd "wifi"
	show_sleep 30
	
	echo -e "iperf3 server ip is $server_ip"
	$ssh_silent_cmd "iperf3 -s -D"
	show_sleep 2
	echo -e "firewall insert port 5201"
	$ssh_silent_cmd "iptables --insert zone_wan_input -j ACCEPT -p tcp --dport 5201 && iptables --insert zone_wan_input -j ACCEPT -p udp --dport 5201"
	show_sleep 2
	echo -e "iperf3 client ip is $client_ip"
	iperf3_output=$($ssh_silent_cmd "ssh root@$client_ip "iperf3 -c $server_ip"" | tail -4 | head -n 2 | awk '{print $7}')
	echo -e "firewall delete port 5201"
	$ssh_silent_cmd "iptables --delete zone_wan_input -j ACCEPT -p tcp --dport 5201 && iptables --delete zone_wan_input -j ACCEPT -p udp --dport 5201"
	show_sleep 2
	echo -e "kill iperf deamon process in server"
	$ssh_silent_cmd "kill -9 \`pidof iperf3\`"
	show_sleep 2
	#echo $iperf3_output
	sender_bitrate=$(echo $iperf3_output | awk '{print $1}')	# In Mbits/sec
	echo -e "Sender Bit rate \t=\t$sender_bitrate Mbits/sec"
	receiver_bitrate=$(echo $iperf3_output | awk '{print $2}')	# In Mbits/sec
	echo -e "Receiver Bit rate\t=\t$receiver_bitrate Mbits/sec"
	receiver_bitrate=$(echo $receiver_bitrate | awk -F . '{print $1}')
	
	#setting to default mode in target client
	echo "/usr/share/simpleconfig/setup.sh $default_mode" > /tmp/temp.cmd
	echo "sleep 60" >> /tmp/temp.cmd
	scp /tmp/temp.cmd root@$default_target_ip:/tmp/
	$ssh_silent_cmd "scp /tmp/temp.cmd root@$client_ip:/tmp/"
	$ssh_silent_cmd "ssh root@$client_ip "/tmp/temp.cmd" &"	# this will take 70 seconds to execute in background. 
	show_sleep 70

	#setting to default mode in target server
	$ssh_silent_cmd "/usr/share/simpleconfig/setup.sh $default_mode" > /dev/null
	show_sleep 60

	#cleaning in ubuntu host, target server and client
	rm /tmp/temp.cmd #/tmp/temp1.cmd
	$ssh_silent_cmd "rm /tmp/temp.cmd" # /tmp/temp1.cmd"
	$ssh_silent_cmd "ssh root@$client_ip "rm /tmp/temp.cmd"" # /tmp/temp1.cmd""
	echo "End of $FUNCNAME"
	if [ "$receiver_bitrate" -ge "$threshold_bitrate" ]; then
		return 1
	else
		return 0
	fi
}

TEST_00018() {
	echo "Starting of $FUNCNAME"
	check_defaults
	if [[ $? == 0 ]]; then
		return 0
	fi
	response_check_client $default_target_ip $client_ip "10"
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "$client_ip is not responsive"
		return 0
	fi
	channel=15     #Channel 15 is 912MHz
	bandwidth=20   #20MHz
	threshold_bitrate=5     # Mbits/sec
	mode="wds_ap"
	client_mode="wds_client"
	server_ip=$($ssh_silent_cmd "ifconfig br-wan" | awk '{print $2}' | head -n 2 | tail -1 | awk -F : '{print $2}')
	echo "echo \"setting $client_mode mode\"" > /tmp/temp.cmd
	echo "/usr/share/simpleconfig/setup.sh $client_mode" >> /tmp/temp.cmd
	echo "echo \"waiting for 60 seconds\"" >> /tmp/temp.cmd
	echo "sleep 60" >> /tmp/temp.cmd
	echo "echo \"setting $channel channel,bandwidth $bandwidth\"" >> /tmp/temp.cmd
	echo "uci set wireless.radio0.channel=$channel" >> /tmp/temp.cmd
	echo "uci set wireless.radio0.chanbw=$bandwidth" >> /tmp/temp.cmd
	echo "uci commit" >> /tmp/temp.cmd
	echo "wifi" >> /tmp/temp.cmd
	echo "sleep 10" >> /tmp/temp.cmd
	#echo "/tmp/temp.cmd &" > /tmp/temp1.cmd
	chmod 777 /tmp/temp.cmd #/tmp/temp1.cmd
	#scp /tmp/temp.cmd /tmp/temp1.cmd root@$default_target_ip:/tmp/
	scp /tmp/temp.cmd root@$default_target_ip:/tmp/
	#$ssh_silent_cmd "scp /tmp/temp.cmd /tmp/temp1.cmd root@$client_ip:/tmp/"
	$ssh_silent_cmd "scp /tmp/temp.cmd root@$client_ip:/tmp/"
	
	echo "setting $client_mode mode in $client_ip"
	$ssh_silent_cmd "ssh root@$client_ip "/tmp/temp.cmd" &"	# this will take 70 seconds to execute in background. 
	show_sleep 70
	echo "setting $mode mode in $server_ip"
	$ssh_silent_cmd "/usr/share/simpleconfig/setup.sh $mode" > /dev/null
	show_sleep 60
	$ssh_silent_cmd "uci set wireless.radio0.channel=$channel"
	$ssh_silent_cmd "uci set wireless.radio0.chanbw=$bandwidth"
	$ssh_silent_cmd "uci commit wireless"
	$ssh_silent_cmd "wifi"
	show_sleep 30
	
	echo -e "iperf3 server ip is $server_ip"
	$ssh_silent_cmd "iperf3 -s -D"
	show_sleep 2
	echo -e "firewall insert port 5201"
	$ssh_silent_cmd "iptables --insert zone_wan_input -j ACCEPT -p tcp --dport 5201 && iptables --insert zone_wan_input -j ACCEPT -p udp --dport 5201"
	show_sleep 2
	echo -e "iperf3 client ip is $client_ip"
	iperf3_output=$($ssh_silent_cmd "ssh root@$client_ip "iperf3 -c $server_ip"" | tail -4 | head -n 2 | awk '{print $7}')
	echo -e "firewall delete port 5201"
	$ssh_silent_cmd "iptables --delete zone_wan_input -j ACCEPT -p tcp --dport 5201 && iptables --delete zone_wan_input -j ACCEPT -p udp --dport 5201"
	show_sleep 2
	echo -e "kill iperf deamon process in server"
	$ssh_silent_cmd "kill -9 \`pidof iperf3\`"
	show_sleep 2
	#echo $iperf3_output
	sender_bitrate=$(echo $iperf3_output | awk '{print $1}')	# In Mbits/sec
	echo -e "Sender Bit rate \t=\t$sender_bitrate Mbits/sec"
	receiver_bitrate=$(echo $iperf3_output | awk '{print $2}')	# In Mbits/sec
	echo -e "Receiver Bit rate\t=\t$receiver_bitrate Mbits/sec"
	receiver_bitrate=$(echo $receiver_bitrate | awk -F . '{print $1}')
	
	#setting to default mode in target client
	echo "/usr/share/simpleconfig/setup.sh $default_mode" > /tmp/temp.cmd
	echo "sleep 60" >> /tmp/temp.cmd
	scp /tmp/temp.cmd root@$default_target_ip:/tmp/
	$ssh_silent_cmd "scp /tmp/temp.cmd root@$client_ip:/tmp/"
	$ssh_silent_cmd "ssh root@$client_ip "/tmp/temp.cmd" &"	# this will take 70 seconds to execute in background. 
	show_sleep 70

	#setting to default mode in target server
	$ssh_silent_cmd "/usr/share/simpleconfig/setup.sh $default_mode" > /dev/null
	show_sleep 60

	#cleaning in ubuntu host, target server and client
	rm /tmp/temp.cmd #/tmp/temp1.cmd
	$ssh_silent_cmd "rm /tmp/temp.cmd" # /tmp/temp1.cmd"
	$ssh_silent_cmd "ssh root@$client_ip "rm /tmp/temp.cmd"" # /tmp/temp1.cmd""
	echo "End of $FUNCNAME"
	if [ "$receiver_bitrate" -ge "$threshold_bitrate" ]; then
		return 1
	else
		return 0
	fi
}

TEST_00019() {
	echo "Starting of $FUNCNAME"
	check_defaults
	if [[ $? == 0 ]]; then
		return 0
	fi
	response_check_client $default_target_ip $client_ip "10"
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "$client_ip is not responsive"
		return 0
	fi
	channel=15     #Channel 15 is 912MHz
	bandwidth=20   #20MHz
	threshold_bitrate=5     # Mbits/sec
	mode="wds_client"
	client_mode="wds_ap"
	server_ip=$($ssh_silent_cmd "ifconfig br-wan" | awk '{print $2}' | head -n 2 | tail -1 | awk -F : '{print $2}')
	echo "echo \"setting $client_mode mode\"" > /tmp/temp.cmd
	echo "/usr/share/simpleconfig/setup.sh $client_mode" >> /tmp/temp.cmd
	echo "echo \"waiting for 60 seconds\"" >> /tmp/temp.cmd
	echo "sleep 60" >> /tmp/temp.cmd
	echo "echo \"setting $channel channel,bandwidth $bandwidth\"" >> /tmp/temp.cmd
	echo "uci set wireless.radio0.channel=$channel" >> /tmp/temp.cmd
	echo "uci set wireless.radio0.chanbw=$bandwidth" >> /tmp/temp.cmd
	echo "uci commit" >> /tmp/temp.cmd
	echo "wifi" >> /tmp/temp.cmd
	echo "sleep 10" >> /tmp/temp.cmd
	#echo "/tmp/temp.cmd &" > /tmp/temp1.cmd
	chmod 777 /tmp/temp.cmd #/tmp/temp1.cmd
	#scp /tmp/temp.cmd /tmp/temp1.cmd root@$default_target_ip:/tmp/
	scp /tmp/temp.cmd root@$default_target_ip:/tmp/
	#$ssh_silent_cmd "scp /tmp/temp.cmd /tmp/temp1.cmd root@$client_ip:/tmp/"
	$ssh_silent_cmd "scp /tmp/temp.cmd root@$client_ip:/tmp/"
	
	echo "setting $client_mode mode in $client_ip"
	$ssh_silent_cmd "ssh root@$client_ip "/tmp/temp.cmd" &"	# this will take 70 seconds to execute in background. 
	show_sleep 70
	echo "setting $mode mode in $server_ip"
	$ssh_silent_cmd "/usr/share/simpleconfig/setup.sh $mode" > /dev/null
	show_sleep 60
	$ssh_silent_cmd "uci set wireless.radio0.channel=$channel"
	$ssh_silent_cmd "uci set wireless.radio0.chanbw=$bandwidth"
	$ssh_silent_cmd "uci commit wireless"
	$ssh_silent_cmd "wifi"
	show_sleep 30
	
	echo -e "iperf3 server ip is $server_ip"
	$ssh_silent_cmd "iperf3 -s -D"
	show_sleep 2
	echo -e "firewall insert port 5201"
	$ssh_silent_cmd "iptables --insert zone_wan_input -j ACCEPT -p tcp --dport 5201 && iptables --insert zone_wan_input -j ACCEPT -p udp --dport 5201"
	show_sleep 2
	echo -e "iperf3 client ip is $client_ip"
	iperf3_output=$($ssh_silent_cmd "ssh root@$client_ip "iperf3 -c $server_ip"" | tail -4 | head -n 2 | awk '{print $7}')
	echo -e "firewall delete port 5201"
	$ssh_silent_cmd "iptables --delete zone_wan_input -j ACCEPT -p tcp --dport 5201 && iptables --delete zone_wan_input -j ACCEPT -p udp --dport 5201"
	show_sleep 2
	echo -e "kill iperf deamon process in server"
	$ssh_silent_cmd "kill -9 \`pidof iperf3\`"
	show_sleep 2
	#echo $iperf3_output
	sender_bitrate=$(echo $iperf3_output | awk '{print $1}')	# In Mbits/sec
	echo -e "Sender Bit rate \t=\t$sender_bitrate Mbits/sec"
	receiver_bitrate=$(echo $iperf3_output | awk '{print $2}')	# In Mbits/sec
	echo -e "Receiver Bit rate\t=\t$receiver_bitrate Mbits/sec"
	receiver_bitrate=$(echo $receiver_bitrate | awk -F . '{print $1}')
	
	#setting to default mode in target client
	echo "/usr/share/simpleconfig/setup.sh $default_mode" > /tmp/temp.cmd
	echo "sleep 60" >> /tmp/temp.cmd
	scp /tmp/temp.cmd root@$default_target_ip:/tmp/
	$ssh_silent_cmd "scp /tmp/temp.cmd root@$client_ip:/tmp/"
	$ssh_silent_cmd "ssh root@$client_ip "/tmp/temp.cmd" &"	# this will take 70 seconds to execute in background. 
	show_sleep 70

	#setting to default mode in target server
	$ssh_silent_cmd "/usr/share/simpleconfig/setup.sh $default_mode" > /dev/null
	show_sleep 60

	#cleaning in ubuntu host, target server and client
	rm /tmp/temp.cmd #/tmp/temp1.cmd
	$ssh_silent_cmd "rm /tmp/temp.cmd" # /tmp/temp1.cmd"
	$ssh_silent_cmd "ssh root@$client_ip "rm /tmp/temp.cmd"" # /tmp/temp1.cmd""
	echo "End of $FUNCNAME"
	if [ "$receiver_bitrate" -ge "$threshold_bitrate" ]; then
		return 1
	else
		return 0
	fi
}

TEST_00020() {
	echo "Starting of $FUNCNAME"
	#mode="mesh_gw"
	echo "End of $FUNCNAME"
	return 2

}

TEST_00021() {
	echo "Starting of $FUNCNAME"
	#mode="wds_ap_gw"
	echo "End of $FUNCNAME"
	return 2

}
TEST_00022() {
	echo "Starting of $FUNCNAME"
	#mode="mesh_multi"
	echo "End of $FUNCNAME"
	return 2

}

TEST_00023() {
	echo "Starting of $FUNCNAME"
	check_defaults
	if [[ $? == 0 ]]; then
		return 0
	fi
	response_check_client $default_target_ip $client_ip "10"
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "$client_ip is not responsive"
		return 0
	fi
	channel=15     #Channel 15 is 912MHz
	bandwidth=20   #20MHz
	threshold_bitrate=5     # Mbits/sec
	mode="dynamic_mesh"
	client_mode="dynamic_mesh"
	server_ip=$($ssh_silent_cmd "ifconfig br-wan" | awk '{print $2}' | head -n 2 | tail -1 | awk -F : '{print $2}')
	echo "echo \"setting $client_mode mode\"" > /tmp/temp.cmd
	echo "/usr/share/simpleconfig/setup.sh $client_mode" >> /tmp/temp.cmd
	echo "echo \"waiting for 60 seconds\"" >> /tmp/temp.cmd
	echo "sleep 60" >> /tmp/temp.cmd
	echo "echo \"setting $channel channel,bandwidth $bandwidth\"" >> /tmp/temp.cmd
	echo "uci set wireless.radio0.channel=$channel" >> /tmp/temp.cmd
	echo "uci set wireless.radio0.chanbw=$bandwidth" >> /tmp/temp.cmd
	echo "uci commit" >> /tmp/temp.cmd
	echo "wifi" >> /tmp/temp.cmd
	echo "sleep 10" >> /tmp/temp.cmd
	#echo "/tmp/temp.cmd &" > /tmp/temp1.cmd
	chmod 777 /tmp/temp.cmd #/tmp/temp1.cmd
	#scp /tmp/temp.cmd /tmp/temp1.cmd root@$default_target_ip:/tmp/
	scp /tmp/temp.cmd root@$default_target_ip:/tmp/
	#$ssh_silent_cmd "scp /tmp/temp.cmd /tmp/temp1.cmd root@$client_ip:/tmp/"
	$ssh_silent_cmd "scp /tmp/temp.cmd root@$client_ip:/tmp/"
	
	echo "setting $mode mode in $client_ip"
	$ssh_silent_cmd "ssh root@$client_ip "/tmp/temp.cmd" &"	# this will take 70 seconds to execute in background. 
	show_sleep 70
	echo "setting $mode mode in $server_ip"
	$ssh_silent_cmd "/usr/share/simpleconfig/setup.sh $mode" > /dev/null
	show_sleep 60
	$ssh_silent_cmd "uci set wireless.radio0.channel=$channel"
	$ssh_silent_cmd "uci set wireless.radio0.chanbw=$bandwidth"
	$ssh_silent_cmd "uci commit wireless"
	$ssh_silent_cmd "wifi"
	show_sleep 30
	response_check_client $default_target_ip $client_ip "10"
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "$client_ip is not responsive"
		return 0
	fi
	
	echo -e "iperf3 server ip is $server_ip"
	$ssh_silent_cmd "iperf3 -s -D"
	$ssh_silent_cmd "iptables --insert zone_wan_input -j ACCEPT -p tcp --dport 5201 \
		  && iptables --insert zone_wan_input -j ACCEPT -p udp --dport 5201"
	iperf3_output=$($ssh_silent_cmd "ssh root@$client_ip "iperf3 -c $server_ip"" | tail -4 | head -n 2 | awk '{print $7}')
	$ssh_silent_cmd "iptables --delete zone_wan_input -j ACCEPT -p tcp --dport 5201 \
				  && iptables --delete zone_wan_input -j ACCEPT -p udp --dport 5201"
	$ssh_silent_cmd "kill -9 \`pidof iperf3\`"
	#echo $iperf3_output
	sender_bitrate=$(echo $iperf3_output | awk '{print $1}')	# In Mbits/sec
	echo -e "Sender Bit rate \t=\t$sender_bitrate Mbits/sec"
	receiver_bitrate=$(echo $iperf3_output | awk '{print $2}')	# In Mbits/sec
	echo -e "Receiver Bit rate\t=\t$receiver_bitrate Mbits/sec"
	receiver_bitrate=$(echo $receiver_bitrate | awk -F . '{print $1}')
	
	#setting to default mode in target client
	echo "setting $default_mode mode in $client_ip"
	echo "/usr/share/simpleconfig/setup.sh $default_mode" > /tmp/temp.cmd
	echo "sleep 60" >> /tmp/temp.cmd
	scp /tmp/temp.cmd root@$default_target_ip:/tmp/
	$ssh_silent_cmd "scp /tmp/temp.cmd root@$client_ip:/tmp/"
	$ssh_silent_cmd "ssh root@$client_ip "/tmp/temp.cmd" &"	# this will take 70 seconds to execute in background. 
	show_sleep 70

	#setting to default mode in target server
	echo "setting $default_mode mode in $server_ip"
	$ssh_silent_cmd "/usr/share/simpleconfig/setup.sh $default_mode" > /dev/null
	show_sleep 60

	#cleaning in ubuntu host, target server and client
	rm /tmp/temp.cmd #/tmp/temp1.cmd
	$ssh_silent_cmd "rm /tmp/temp.cmd" # /tmp/temp1.cmd"
	$ssh_silent_cmd "ssh root@$client_ip "rm /tmp/temp.cmd"" # /tmp/temp1.cmd""
	echo "End of $FUNCNAME"
	if [ "$receiver_bitrate" -ge "$threshold_bitrate" ]; then
		return 1
	else
		return 0
	fi
}

TEST_00024() {
	echo "Starting of $FUNCNAME"
	echo "End of $FUNCNAME"
	return 2

}

TEST_00025() {
	echo "Starting of $FUNCNAME"
	check_defaults
	if [[ $? == 0 ]]; then
		return 0
	fi
	model1="RM-915-2H-XS"
	model2="RM-915-2H-PS"
	echo "checking communication compatibility between models $model1 and $model2"
	response_check_client $default_target_ip $client_ip "10"
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "$client_ip is not responsive"
		return 0
	fi
	$ssh_silent_cmd "ssh root@$client_ip "fes_model.sh set $model2""
	$ssh_silent_cmd "ssh root@$client_ip "reboot""
	response_check $default_target_ip "10"
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "$default_target_ip is not responsive"
		return 0
	fi
	$ssh_silent_cmd "fes_model.sh set $model1"
	$ssh_silent_cmd "reboot"
	show_sleep 2	# takes 2 seconds for network interface to go down
	
	wait_time=200	# waiting time in seconds until reboot completes.
	echo "waiting for maximum of $wait_time seconds to boot:"
	for (( c=1; c<=$wait_time; c++ ))
	do
		resp=$(ping -c 1 -i 1 -w 1 $default_target_ip | head -2 | tail -1 | awk '{print $7}' | awk -F = '{print $1}')
		if [[ $resp  != "time" ]]; then
			echo -ne "$c/$wait_time\r"
		else
			boot_time="$c"
			echo -e "boot time is approximately $boot_time seconds."
			break
		fi
	done
	echo "giving some time to join into mesh and interface up"
	show_sleep 200
	model1_check=$($ssh_silent_cmd "fes_model.sh get")
	model2_check=$($ssh_silent_cmd "ssh root@$client_ip "fes_model.sh get"")
	if [[ $model1_check != $model1 ]]; then
		echo "Failed to set model $model1_check into $model1"
		return 0
	fi
	if [[ $model2_check != $model2 ]]; then
		echo "Failed to set model $model2_check into $model2"
		return 0
	fi
	
	channel=$default_channel		#Channel 15 is 912MHz, default is 12 i.e 915MHz
	bandwidth=$default_bandwidth	#20MHz
	threshold_bitrate=5	# Mbits/sec
	mode="mesh"
	$ssh_silent_cmd "/usr/share/simpleconfig/setup.sh $mode" > /dev/null
	show_sleep 60
	$ssh_silent_cmd "uci set wireless.radio0.channel=$channel"
	$ssh_silent_cmd "uci set wireless.radio0.chanbw=$bandwidth"
	$ssh_silent_cmd "uci commit wireless"
	$ssh_silent_cmd "wifi"
	show_sleep 15
	server_ip=$($ssh_silent_cmd "ifconfig br-wan" | awk '{print $2}' | head -n 2 | tail -1 | awk -F : '{print $2}')
	echo -e "iperf3 server ip is $server_ip"
	$ssh_silent_cmd "iperf3 -s -D"
	$ssh_silent_cmd "iptables --insert zone_wan_input -j ACCEPT -p tcp --dport 5201 \
		  && iptables --insert zone_wan_input -j ACCEPT -p udp --dport 5201"
	iperf3_output=$($ssh_silent_cmd "ssh root@$client_ip "iperf3 -c $server_ip"" | tail -4 | head -n 2 | awk '{print $7}')
	$ssh_silent_cmd "iptables --delete zone_wan_input -j ACCEPT -p tcp --dport 5201 \
				  && iptables --delete zone_wan_input -j ACCEPT -p udp --dport 5201"
	$ssh_silent_cmd "kill -9 \`pidof iperf3\`"
	#echo $iperf3_output
	sender_bitrate=$(echo $iperf3_output | awk '{print $1}')	# In Mbits/sec
	echo -e "Sender Bit rate \t=\t$sender_bitrate Mbits/sec"
	receiver_bitrate=$(echo $iperf3_output | awk '{print $2}')	# In Mbits/sec
	echo -e "Receiver Bit rate\t=\t$receiver_bitrate Mbits/sec"
	receiver_bitrate=$(echo $receiver_bitrate | awk -F . '{print $1}')
	
	$ssh_silent_cmd "ssh root@$client_ip "fes_model.sh set $default_model""
	$ssh_silent_cmd "ssh root@$client_ip "reboot""
	$ssh_silent_cmd "fes_model.sh set $default_model"
	$ssh_silent_cmd "reboot"
	show_sleep 2	# takes 2 seconds for network interface to go down
	
	wait_time=200	# waiting time in seconds until reboot completes.
	echo "waiting for maximum of $wait_time seconds to boot:"
	for (( c=1; c<=$wait_time; c++ ))
	do
		resp=$(ping -c 1 -i 1 -w 1 $default_target_ip | head -2 | tail -1 | awk '{print $7}' | awk -F = '{print $1}')
		if [[ $resp  != "time" ]]; then
			echo -ne "$c/$wait_time\r"
		else
			boot_time="$c"
			echo -e "boot time is approximately $boot_time seconds."
			break
		fi
	done
	echo "giving some time to join into mesh and interface up"
	show_sleep 200
	echo "End of $FUNCNAME"
	if [ "$receiver_bitrate" -ge "$threshold_bitrate" ]; then
		return 1
	else
		return 0
	fi
}

TEST_00026() {
	echo "Starting of $FUNCNAME"
	check_defaults
	if [[ $? == 0 ]]; then
		return 0
	fi
	threshold_boot_time=25	# extected boot time in seconds to pass the test

	resp=$(ping -c 1 -i 1 -w 1 $default_target_ip | head -2 | tail -1 | awk '{print $7}' | awk -F = '{print $1}')
	if [[ $resp  == "time" ]]; then
		echo "target is alive, rebooting to capture the boot time..."
	else
		echo "target is not reachable at $default_target_ip"
		return 0
	fi
	$ssh_silent_cmd "reboot"
	show_sleep 2	# takes 2 seconds for network interface to go down
	wait_time=300	# waiting time in seconds until reboot completes.
	echo "waiting for maximum of $wait_time seconds to boot:"
	for (( c=1; c<=$wait_time; c++ ))
	do
		resp=$(ping -c 1 -i 1 -w 1 $default_target_ip | head -2 | tail -1 | awk '{print $7}' | awk -F = '{print $1}')
		if [[ $resp  != "time" ]]; then
			echo -ne "$c/$wait_time\r"
		else
			boot_time="$c"
			echo -e "boot time is approximately $boot_time seconds."
			break
		fi
	done
	echo "End of $FUNCNAME"
	if [[ $boot_time != "" ]]; then
		if [ "$boot_time" -le "$threshold_boot_time" ]; then
			return 1
		else
			return 0
		fi
	else
		return 0
	fi
	
}

TEST_00027() {
	echo "Starting of $FUNCNAME"
	check_defaults
	if [[ $? == 0 ]]; then
		return 0
	fi
	test_value=590
	current_value=$($ssh_silent_cmd "dl-prism-ctrl 0 9")
	#echo $current_value
	new_value=$($ssh_silent_cmd "dl-prism-ctrl 1 9 $test_value")
	#echo $new_value
	$ssh_silent_cmd "dl-prism-ctrl 1 9 $current_value > /dev/null"
	echo "End of $FUNCNAME"
	if [[ $new_value == $test_value ]]; then
		return 1
	else
		return 0
	fi
}

TEST_00028() {
	echo "Starting of $FUNCNAME"
	check_defaults
	if [[ $? == 0 ]]; then
		return 0
	fi
	test_value=590
	current_value=$($ssh_silent_cmd "dl-prism-ctrl 0 9")
	#echo $current_value

	$ssh_silent_cmd "dl-prism-ctrl 1 9 $test_value > /dev/null"
	new_value=$($ssh_silent_cmd "dl-prism-ctrl 0 9")
	#echo $new_value
	$ssh_silent_cmd "dl-prism-ctrl 1 9 $current_value > /dev/null"
	echo "End of $FUNCNAME"
	if [[ $new_value == $test_value ]]; then
		return 1
	else
		return 0
	fi
}

TEST_00029() {
	echo "Starting of $FUNCNAME"
	echo "End of $FUNCNAME"
	return 2

}

TEST_00030() {
	echo "Starting of $FUNCNAME"
	check_defaults
	if [[ $? == 0 ]]; then
		return 0
	fi
	page1="https://$default_target_ip/cgi-bin/luci/"
	page2="https://$default_target_ip/cgi-bin/luci/admin/status/overview"
	page3="https://$default_target_ip/cgi-bin/luci/admin/system/system"
	page_1_2_key="Status"
	page_3a_key="System"
	page_3b_key="files"
	page_3c_key="Download"
	find_keyword $page1 $page_1_2_key
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "loading $page1 failed"
		return 0
	fi
	find_keyword $page2 $page_1_2_key
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "loading $page2 failed"
		return 0
	fi
	find_keyword $page3 $page_3a_key
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "loading $page3 failed"
		return 0
	fi
	find_keyword $page3 $page_3b_key
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "loading $page3 failed"
		return 0
	fi
	find_keyword $page3 $page_3c_key
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "loading $page3 failed"
		return 0
	fi
	echo "End of $FUNCNAME"
	return 1
}

TEST_00031() {
	echo "Starting of $FUNCNAME"
	check_defaults
	if [[ $? == 0 ]]; then
		return 0
	fi
	page1="https://$default_target_ip/cgi-bin/luci/"
	page2="https://$default_target_ip/cgi-bin/luci/admin/status/overview"
	page3="https://$default_target_ip/cgi-bin/luci/mini/network/wireless"
	page4="https://$default_target_ip/cgi-bin/luci/mini/network/wireless/radio0.network1"
	page5="https://$default_target_ip/cgi-bin/luci/admin/network/wireless"
	page6="https://$default_target_ip/cgi-bin/luci/admin/network/wireless/radio0.network1"
	page_1_2_key="Status"
	page_3_to_6_key="Wireless"

	find_keyword $page1 $page_1_2_key
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "loading $page1 failed"
		return 0
	fi
	find_keyword $page2 $page_1_2_key
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "loading $page2 failed"
		return 0
	fi
	find_keyword $page3 $page_3_to_6_key
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "loading $page3 failed"
		return 0
	fi
	find_keyword $page4 $page_3_to_6_key
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "loading $page4 failed"
		return 0
	fi
	find_keyword $page5 $page_3_to_6_key
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "loading $page5 failed"
		return 0
	fi
	find_keyword $page6 $page_3_to_6_key
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "loading $page6 failed"
		return 0
	fi
	echo "End of $FUNCNAME"
	return 1
}

TEST_00032() {
	echo "Starting of $FUNCNAME"
	test_value=""
	new_value=$($ssh_silent_cmd "iptables -t nat -I POSTROUTING -s 192.168.77.0/24 -j NETMAP --to 192.168.78.0/24")
	#echo $new_value
	echo "End of $FUNCNAME"
	if [[ $new_value == $test_value ]]; then
			return 1
	else
			return 0
	fi
}

TEST_00033() {
	echo "Starting of $FUNCNAME"
	check_defaults
	if [[ $? == 0 ]]; then
		return 0
	fi
	page1="https://$default_target_ip/cgi-bin/luci/"
	page2="https://$default_target_ip/cgi-bin/luci/admin/status/overview"
	page3="https://$default_target_ip/cgi-bin/luci/mini/network/wireless"
	page4="https://$default_target_ip/cgi-bin/luci/admin/network/wireless"
	page5="https://$default_target_ip/cgi-bin/luci/mini/network/wireless/radio0.network1"
	page6="https://$default_target_ip/cgi-bin/luci/admin/network/wireless/radio0.network1"
	page_1_2_key="Status"
	page_3_4_key="Wireless"
	page_5_6_key="General"

	find_keyword $page1 $page_1_2_key
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "loading $page1 failed"
		return 0
	fi
	find_keyword $page2 $page_1_2_key
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "loading $page2 failed"
		return 0
	fi
	find_keyword $page3 $page_3_4_key
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "loading $page3 failed"
		return 0
	fi
	find_keyword $page4 $page_3_4_key
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "loading $page4 failed"
		return 0
	fi
	find_keyword $page5 $page_5_6_key
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "loading $page5 failed"
		return 0
	fi
	find_keyword $page6 $page_5_6_key
	ret=$?
	if [[ $ret == 0 ]]; then
		echo "loading $page6 failed"
		return 0
	fi
	echo "End of $FUNCNAME"
	return 1
}

TEST_00034() {
	echo "Starting of $FUNCNAME"
	echo "End of $FUNCNAME"
	return 2

}

TEST_00035() {
	echo "Starting of $FUNCNAME"
	echo "End of $FUNCNAME"
	return 2

}

TEST_00036() {
	echo "Starting of $FUNCNAME"
	echo "End of $FUNCNAME"
	return 2

}

TEST_00037() {
	echo "Starting of $FUNCNAME"
	echo "End of $FUNCNAME"
	return 2

}

TEST_00038() {
	echo "Starting of $FUNCNAME"
	echo "End of $FUNCNAME"
	return 2

}

TEST_00039() {
	echo "Starting of $FUNCNAME"
	echo "End of $FUNCNAME"
	return 2

}

TEST_00040() {
	echo "Starting of $FUNCNAME"
	echo "End of $FUNCNAME"
	return 2

}

TEST_00041() {
	echo "Starting of $FUNCNAME"
	echo "End of $FUNCNAME"
	return 2

}

print_result() {
	
	if [[ $1 == $success ]]; then
		echo "------------------------------------------------------" >> /tmp/test.log
		echo -e "\t$test\t\t==>\tPASS" >> /tmp/test.log
		echo "------------------------------------------------------" >> /tmp/test.log
	elif [[ $1 == $fail ]]; then
		echo "------------------------------------------------------" >> /tmp/test.log
		echo -e "$test\t\t==>\tFAIL" >> /tmp/test.log
		echo "------------------------------------------------------" >> /tmp/test.log
	elif [[ $1 == $not_available ]]; then
		echo "------------------------------------------------------" >> /tmp/test.log
		echo -e "\t$test\t\t==>\tNOT AVAILABLE" >> /tmp/test.log
		echo "------------------------------------------------------" >> /tmp/test.log
	else
		echo "------------------------------------------------------" >> /tmp/test.log
		echo -e "\t$test\t\t==>\tUnknown return value" >> /tmp/test.log
		echo "------------------------------------------------------" >> /tmp/test.log
	fi
}

main(){
	echo "Module test $FUNCNAME function started" > /tmp/test.log
	total_tests=41
	success=1
	fail=0
	not_available=2
	
	if [[ $1 != "" ]]; then
		val=$(($1))
		if [ "$val" -le "$total_tests" ]; then
			if [ "$val" -le "9" ]; then
				TEST_0000$val
				ret=$?
				test="TEST_0000$val"
			else
				TEST_000$val
				ret=$?
				test="TEST_000$val"
			fi
			print_result $ret
		fi
	else
		for i in {1..9}
		do
			TEST_0000$i
			ret=$?
			test="TEST_0000$i"
			print_result $ret
		done
		for i in `seq 10 $total_tests`
		do
			TEST_000$i
			ret=$?
			test="TEST_0000$i"
			print_result $ret
		done
	fi
	echo "Module test $FUNCNAME function completed" >> /tmp/test.log
	cat /tmp/test.log
#	rm /tmp/test.log
}
main $1
runtime_end=$(date +%s.%N)
dt=$(echo "$runtime_end - $runtime_start" | bc)
dd=$(echo "$dt/86400" | bc)
dt2=$(echo "$dt-86400*$dd" | bc)
dh=$(echo "$dt2/3600" | bc)
dt3=$(echo "$dt2-3600*$dh" | bc)
dm=$(echo "$dt3/60" | bc)
ds=$(echo "$dt3-60*$dm" | bc)
printf "Total runtime: %d:%02d:%02d:%02.4f\n" $dd $dh $dm $ds
echo "Module test completed successfully"
