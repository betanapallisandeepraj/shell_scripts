#!/bin/bash

timeout=240
counter=0
timeout_pre=10
#ports=(enp5s0 enp7s0 enp6s0 enp4s0)
ports=(enp2s0 enp3s0)
numPorts=2
# get port status information
portStatus=(0 0)
portIPV6=(0 0)
portIPV4=(0 0)
wakeup_check=0
wakeup() {
  startTime=$(date +%s)
  currentTime=$(date +%s)
  timeDiff=$((currentTime - startTime))
  tmp=0
  while (($(echo "$tmp < $numPorts" | bc -l))) && (($(echo "$timeDiff < $timeout" | bc -l))); do
    tmp=0
    currentTime=$(date +%s)
    timeDiff=$((currentTime - startTime))
    restart=$(($timeDiff % 60))
    if [ $restart -eq 0 ]; then
      #network
      echo "network"
    fi

    echo $timeDiff
    for i in {0..1}; do
      echo "port=${ports[$i]}"
      portStatus[$i]=$(ip -6 neighbor | grep ${ports[$i]} | grep "REACHABLE" | awk '{print $NF}')
      echo "port status=${portStatus[$i]}"
      if [ "${portStatus[$i]}" == "REACHABLE" ]; then
        tmp=$((tmp + 1))
        portIPV6[$i]=$(ip -6 neighbor | grep ${ports[$i]} | grep "REACHABLE" | awk '{print $1}')
        echo "port ${ports[$i]} is connected to device ${portIPV6[$i]}"
      else
        portIPV6[$i]=$(ip -6 neighbor | grep ${ports[$i]} | grep "REACHABLE" | awk '{print $1}')
        # wake up the port with a ping
        ping6 -c 1 "${portIPV6[$i]}"%"${ports[$i]}" 2>&1 >/dev/null
        ping6 -c 1 "ff02::1"%"${ports[$i]}" 2>&1 >/dev/null
      fi
    done
    sleep 1
  done
  if [[ "$tmp" -lt $numPorts ]] && [[ "$wakeup_check" -eq 0 ]]; then
    wakeup_check=1
    network
    wakeup
  fi

  if [[ "$tmp" -lt $numPorts ]] && [[ "$wakeup_check" -eq 1 ]]; then
    echo "ERROR: Not all ports are reachable, Check the connectors"
    exit -1
  fi
  wakeup_check=0
}
#wakeup

ping_all_backup() {
  all_interfaces=$(ifconfig | grep encap | awk '{print $1}' | tr '\n' ' ')
  for interface in $all_interfaces; do
    #echo $interface
    is_wired_connection=$(nmcli connection show | grep $interface | awk '{print $3}')
    # echo "$is_wired_connection"
    # for ubuntu string is 802-3-ethernet, for kali linux string is ethernet for wired connections
    if [ "$is_wired_connection" == "802-3-ethernet" ]; then
      ipv6=$(ifconfig $interface | grep inet6 | awk '{print $3}' | awk -F / '{print $1}')
      #echo $ipv6
      ipv6_1st_2bytes=$(echo $ipv6 | awk -F : '{print $1}')
      #echo $ipv6_1st_2bytes
      #echo $ipv6_1st_2bytes | awk '{print length}'
      if [ $(echo $ipv6_1st_2bytes | awk '{print length}') -eq 4 ]; then
        ping6 -c 2 $ipv6_1st_2bytes::%$interface >/dev/null
        #echo $ipv6_1st_2bytes | awk '{print length}'
      fi
      # else
      # echo "is_wired_connection string mismatch or $interface not available: refer command <nmcli connection show>"
      # print_with_time "is_wired_connection string mismatch or $interface not available: refer command <nmcli connection show>"
      # echo "detected other interface=$interface, not considering"
      # print_with_time "detected other interface=$interface, not considering"
    fi
    #echo "--------"
  done
}

ping_all() {
  all_interfaces=$(ifconfig | grep encap | awk '{print $1}' | tr '\n' ' ')
  for interface in $all_interfaces; do
    #echo "interface=$interface"
    is_wired_connection=$(nmcli connection show | grep $interface | awk '{print $3}')
    # echo "$is_wired_connection"
    # for ubuntu string is 802-3-ethernet, for kali linux string is ethernet for wired connections
    if [ "$is_wired_connection" == "802-3-ethernet" ]; then
      host_ipv6=$(ifconfig $interface | grep inet6 | awk '{print $3}' | awk -F / '{print $1}')
      echo "interface=$interface,host_ipv6=$host_ipv6"
      ping6 -c 5 "ff02::1%$interface" >/dev/null
    fi
    echo "--------"
  done
}

wakeup1() {
  echo "${LINENO}:$FUNCNAME function started"
  startTime=$(date +%s)
  currentTime=$(date +%s)
  timeDiff=$((currentTime - startTime))
  tmp=0
  ping_all
  while (($(echo "$tmp < $numPorts" | bc -l))) && (($(echo "$timeDiff < $timeout" | bc -l))); do
    tmp=0
    currentTime=$(date +%s)
    timeDiff=$((currentTime - startTime))
    restart=$(($timeDiff % 60))
    if [ $restart -eq 0 ]; then
      #network
      echo "network"
    fi

    echo $timeDiff
    ping_all

    ip -6 neighbor | grep router | grep "REACHABLE" | awk '{print $1}' | sort -u >/tmp/abc
    if [ $(wc -l </tmp/abc) -lt $numPorts ]; then
      echo "line count=$(wc -l </tmp/abc)"
      continue
    fi
    echo "line count=$(wc -l </tmp/abc)"
    i=0
    while IFS= read -r line; do
      file_line=$line
      echo "${LINENO}:$file_line"
      portIPV6[$i]=$file_line
      echo "portIPV6[$i]=${portIPV6[$i]}"
      i=$((i + 1))
    done <"/tmp/abc"

    for i in {0..1}; do
      for j in {0..1}; do
        #echo "${ports[$j]},portipv4[$i]=${portIPV4[$i]},portIPV6[$i]=${portIPV6[$i]}"
        if [ "${portIPV4[$i]}" != 0 ]; then
          continue
        fi
        var=$(ssh root@${portIPV6[$i]}%${ports[$j]} "ifconfig br-wan")
        var=$(echo $var | awk -F addr: '{print $2}' | awk '{print $1}')
        #echo "var=$var"
        if [ "${portIPV4[$i]}" == 0 ]; then
          #echo "123"
          portIPV4[$i]=$var
        fi
        echo "${ports[$j]},portipv4[$i]=${portIPV4[$i]},portIPV6[$i]=${portIPV6[$i]}"
      done
    done
    exit
    <<xyz
    for i in {0..1}; do
      echo "${LINENO}:for loop starting iteration=$i"
      ping_all
      echo "${LINENO}:port=${ports[$i]}" #############
      echo $(ip -6 neighbor | grep ${ports[$i]})
      portStatus[$i]=$(ip -6 neighbor | grep ${ports[$i]} | tail -1 | grep "REACHABLE" | awk '{print $NF}')
      echo ${portStatus[$i]}
      echo "${LINENO}:portstatus=${portStatus[$i]}"
      if [ "${portStatus[$i]}" == "REACHABLE" ]; then
        portIPV6[$i]=$(ip -6 neighbor | grep "${ports[$i]} lladdr" | awk '{if(length($1)>6)print $1}')
        echo "${LINENO}:portIPV6=${portIPV6[$i]}" #############
        if [ "${portIPV6[$i]}" == "" ]; then
          echo "${LINENO}:wait for 2 seconds"
          sleep 2
          wakeup1
        fi
        # if [ $(echo ${portIPV6[$i]} | awk '{print length}') -le 6 ]; then
        if [ "${ports[$i]}" == "" ]; then
          echo "${LINENO}:wait for 5 seconds"
          sleep 5
          wakeup1
        fi
	ip -6 neighbor | grep router | grep "REACHABLE" | awk '{print $1}' | sort -u > /tmp/abc
	if [ $(wc -l </tmp/abc) -lt $numPorts ]; then
		echo "line count=$(wc -l </tmp/abc)"
		continue;
	fi
        tmp=$((tmp + 1))
        echo "tmp=$tmp" ##############################	

	
        echo "port ${ports[$i]} is connected to device ${portIPV6[$i]}"
      fi
      echo "${LINENO}:for loop ending iteration=$i"
    done
xyz
    sleep 1
  done

  if [ "$tmp" -lt $numPorts ]; then
    echo "ERROR: Not all ports are reachable, Check the connectors"
    #exit_routine
  fi
  echo "${LINENO}:$FUNCNAME function completed"
}

wakeup1
