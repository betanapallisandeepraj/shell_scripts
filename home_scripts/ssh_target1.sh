#!/bin/bash
ip=$(cat ~/target1_ip.txt)
ssh -q -o "StrictHostKeyChecking no" root@$ip $1
