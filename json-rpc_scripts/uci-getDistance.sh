TOKEN=$(cat ubus_token)
IPADDR=$(cat ipaddr)

echo $IPADDR
echo $TOKEN

curl -k https://$IPADDR/ubus -d '
{ 
  "jsonrpc": "2.0", 
  "id": 1, 
  "method": "call", 
  "params": [ '\"$TOKEN\"', "uci", "get", {"config":"wireless","section":"radio0","option":"distance"} ] 
}' | jq -r '.result[1]'
