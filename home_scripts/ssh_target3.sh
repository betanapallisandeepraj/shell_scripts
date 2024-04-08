#!/bin/bash
ip=$(cat ~/target3_ip.txt)
ssh -q -o "StrictHostKeyChecking no" root@$ip $1
