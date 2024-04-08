#!/bin/bash
ip=$(cat ~/testbed0_ip.txt)
scp -r $1 doodle@$ip:~/Downloads/
