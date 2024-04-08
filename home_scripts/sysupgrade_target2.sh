#!/bin/bash
ip=$(cat ~/target2_ip.txt)
scp -q -o "StrictHostKeyChecking no" -r $1 root@$ip:/tmp/
ssh -q -o "StrictHostKeyChecking no" root@$ip "sysupgrade -n /tmp/$1"
