#!/bin/bash
ip=$(cat ~/i9_pc_ip.txt)
ssh sandeepraj@$ip $1
