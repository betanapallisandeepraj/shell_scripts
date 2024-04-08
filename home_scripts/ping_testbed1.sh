#!/bin/bash
ip=$(cat ~/testbed1_ip.txt)
echo "target ip is $ip, pinging it.... "
ping $ip
