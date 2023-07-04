#!/bin/bash
ping_all() {
  while ((1)); do
    all_interfaces=$(ifconfig | grep encap | awk '{print $1}' | tr '\n' ' ')
    for interface in $all_interfaces; do
      #echo $interface
      is_wired_connection=$(nmcli connection show | grep $interface | awk '{print $5}')
      #echo "$is_wired_connection"
      # for ubuntu string is 802-3-ethernet, for kali linux string is ethernet for wired connections
      if [ "$is_wired_connection" == "802-3-ethernet" ]; then
        ipv6=$(ifconfig $interface | grep inet6 | awk '{print $3}' | awk -F / '{print $1}')
        # echo $ipv6
        ipv6_1st_2bytes=$(echo $ipv6 | awk -F : '{print $1}')
        # echo $ipv6_1st_2bytes
        # echo $ipv6_1st_2bytes | awk '{print length}'
        if [ $(echo $ipv6_1st_2bytes | awk '{print length}') -eq 4 ]; then
          ping6 -c 2 $ipv6_1st_2bytes::%$interface >/dev/null
          # ping6 -c 2 $ipv6_1st_2bytes::%$interface
          sleep 1
          # echo $ipv6_1st_2bytes | awk '{print length}'
        fi
      fi
    done
  done
}
ping_all
