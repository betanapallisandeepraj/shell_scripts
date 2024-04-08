#!/bin/bash
ip=$(cat ~/testbed3_ip.txt)
scp -r $1 doodle@$ip:~/Downloads/
