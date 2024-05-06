#!/bin/bash
ip=$(cat ~/target2_ip.txt)
echo "target ip is $ip, pinging it.... "
ping $ip
