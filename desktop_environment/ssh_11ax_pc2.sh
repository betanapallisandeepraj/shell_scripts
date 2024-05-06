#!/bin/bash
ip=$(cat ~/11ax_pc2_ip.txt)
ssh doodle@$ip $1
