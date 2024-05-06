#!/bin/bash
ip=$(cat ~/testbed2_ip.txt)
ssh doodle@$ip $1
