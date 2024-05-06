#!/bin/bash
ip=$(cat ~/testbed2_ip.txt)
echo "target ip is $ip, pinging it.... "
ping $ip
