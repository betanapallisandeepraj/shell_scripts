#!/bin/bash
ip=$(cat ~/target2_ip.txt)
ssh -q -o "StrictHostKeyChecking no" root@$ip $1
