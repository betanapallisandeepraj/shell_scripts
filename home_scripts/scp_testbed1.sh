#!/bin/bash
ip=$(cat ~/testbed1_ip.txt)
scp -r $1 doodle@$ip:~/Downloads/
