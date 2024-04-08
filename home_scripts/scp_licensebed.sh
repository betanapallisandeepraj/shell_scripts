#!/bin/bash
ip=$(cat ~/licensebed_ip.txt)
scp -r $1 doodle@$ip:~/Downloads/
