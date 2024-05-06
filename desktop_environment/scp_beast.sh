#!/bin/bash
ip=$(cat ~/beast_ip.txt)
scp -q -o "StrictHostKeyChecking no" -r $1 doodle@$ip:~/Downloads/
