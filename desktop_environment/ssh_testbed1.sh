#!/bin/bash
ip=$(cat ~/testbed1_ip.txt)
ssh doodle@$ip $1
