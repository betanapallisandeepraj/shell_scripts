#!/bin/bash
ip=$(cat ~/target1_ip.txt)
scp -q -o "StrictHostKeyChecking no" -r $1 root@$ip:/tmp/
