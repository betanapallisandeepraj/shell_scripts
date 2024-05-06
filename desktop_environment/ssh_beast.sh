#!/bin/bash
ip=$(cat ~/beast_ip.txt)
ssh doodle@$ip $1 ""
