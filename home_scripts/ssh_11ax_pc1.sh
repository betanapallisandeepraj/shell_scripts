#!/bin/bash
ip=$(cat ~/11ax_pc1_ip.txt)
ssh doodle@$ip $1
