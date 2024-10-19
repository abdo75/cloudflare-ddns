#!/bin/bash

logdest="local7.info"
myip=$(curl -s "https://api.ipify.org")
gdip=$(curl --request GET \
  --url https://api.cloudflare.com/client/v4/zones/{zone_id}/dns_records/{dns_record_id} \
  --header 'Content-Type: application/json' \
  --header 'X-Auth-Email: API_EMAIL' \
  --header 'X-Auth-Key: API_TOKEN' | jq -r '.result.content')

echo "$(date '+%Y-%m-%d %H:%M:%S') - Current External IP is $myip, Cloudflare DNS IP is $gdip"

if [ "$gdip" != "$myip" ] && [ "$myip" != "" ]; then
  echo "IP has changed!! Updating on Cloudflare"
  curl --request PUT \
    --url https://api.cloudflare.com/client/v4/zones/{zone_id}/dns_records/{dns_record_id} \
    --header 'Content-Type: application/json' \
    --header 'X-Auth-Email: API_EMAIL' \
    --header 'X-Auth-Key: API_TOKEN' \
    --data "{\"content\": \"$myip\",\"name\": \"domain.tld\",\"proxied\": false,\"type\": \"A\",\"comment\": \"Dynamic DNS\",\"ttl\": 600}"
  logger -p $logdest "Changed IP on gader.cc from ${gdip} to ${myip}"
fi