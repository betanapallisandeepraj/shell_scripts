#!/bin/bash
ip=$(cat ~/testbed3_ip.txt)
ssh doodle@$ip $1
