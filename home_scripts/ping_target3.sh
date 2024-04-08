#!/bin/bash
ip=$(cat ~/target3_ip.txt)
echo "target ip is $ip, pinging it.... "
ping $ip
