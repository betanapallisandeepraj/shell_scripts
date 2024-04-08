#!/bin/bash
ip=$(cat ~/testbed4_ip.txt)
ssh doodle@$ip $1
