#!/bin/bash
ip=$(cat ~/licensebed_ip.txt)
ssh doodle@$ip $1
