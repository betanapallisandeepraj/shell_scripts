IPADDR=$(cat ipaddr)
echo $IPADDR
USER=$(cat user)
PW=$(cat password)

curl --http2 -k https://$IPADDR/ubus -d '
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "call",
  "params": [ "00000000000000000000000000000000", "session", "login", { "username": '\"$USER\"', "password": '\"$PW\"'  } ]
}'  | jq -r '.result[1].ubus_rpc_session' > ubus_token

TOKEN=$(cat ubus_token)
echo $TOKEN
