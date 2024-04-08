#!/bin/bash
ip=$(cat ~/testbed2_ip.txt)
scp -r $1 doodle@$ip:~/Downloads/
