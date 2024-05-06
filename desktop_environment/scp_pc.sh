#!/bin/bash
ip=$(cat ~/i9_pc_ip.txt)
scp -r $1 sandeepraj@$ip:~/Downloads/
