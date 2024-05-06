#!/bin/bash
ip=$(cat ~/target1_ip.txt)
echo "target ip is $ip, pinging it.... "
ping $ip
