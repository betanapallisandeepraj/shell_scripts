#!/bin/bash
ip=$(cat ~/testbed0_ip.txt)
ssh doodle@$ip $1
