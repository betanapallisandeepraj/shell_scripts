#!/bin/sh
echo "Content-Type: application/json"
echo ""
# Fetch network status using ifconfig command
ip_address=$(ifconfig br-wan | grep "inet addr:" | awk '{print $2}' | awk -F : '{print $2}')
gateway=$(ip route | awk '/default via/{print $3}')
dns_servers=$(cat /etc/resolv.conf | awk '/nameserver/{print $2}' | tr '\n' ',' | sed 's/,$//')
time_stamp=$(date)
# Construct JSON response
json_response=$(
  cat <<EOF
{
  "ip_address": "$ip_address",
  "gateway": "$gateway",
  "dns_servers": ["$dns_servers"],
  "time_stamp":"$time_stamp"
}
EOF
)
# Output the JSON response
echo "$json_response"
