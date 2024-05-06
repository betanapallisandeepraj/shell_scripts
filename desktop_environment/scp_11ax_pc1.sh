#!/bin/bash
ip=$(cat ~/11ax_pc1_ip.txt)
scp -r $1 doodle@$ip:~/Downloads/
