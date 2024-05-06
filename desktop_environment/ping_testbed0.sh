#!/bin/bash
ip=$(cat ~/testbed0_ip.txt)
echo "target ip is $ip, pinging it.... "
ping $ip
