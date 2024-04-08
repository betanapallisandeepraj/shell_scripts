#!/bin/bash
ip=$(cat ~/target3_ip.txt)
scp -q -o "StrictHostKeyChecking no" -r $1 root@$ip:/tmp/
