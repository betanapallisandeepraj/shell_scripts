#!/bin/bash
ip=$(cat ~/licensebed_ip.txt)
echo "target ip is $ip, pinging it.... "
ping $ip
