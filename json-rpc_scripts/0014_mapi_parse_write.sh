#!/bin/bash
IPADDR="192.168.153.1"
USER="root"
PW="DoodleSmartRadio"

TOKEN=$(curl --http2 -k https://$IPADDR/ubus -d '
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "call",
  "params": [ "00000000000000000000000000000000", "session", "login", { "username": '\"$USER\"', "password": '\"$PW\"'  } ]
}'  2>/dev/null | jq -r '.result[1].ubus_rpc_session')

output=$(curl -k https://$IPADDR/ubus -d '
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "call",
  "params": [ '\"$TOKEN\"', "file", "mapi_parse", {"command":"cmd0", "params": ["write", "arg0", "arg1", "arg2"]} ]
}' 2>/dev/null | jq -r '.result[1]')

echo $output | jq .
