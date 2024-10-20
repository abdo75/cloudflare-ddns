#!/bin/bash

logdest="local7.info"
domain="EXAMPLE.COM"
zoneid="ZONE_ID"
api_token="API_TOKEN"
dns_record_id="DNS_RECORD_ID"
myip=$(curl -s "https://api.ipify.org")
gdip=$(curl -X GET \
  https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records/$dns_record_id \
  -H "Authorization: Bearer $api_token' | jq -r '.result.content")

echo "$(date '+%Y-%m-%d %H:%M:%S') - Current External IP is $myip, Cloudflare DNS IP is $gdip"

if [ "$gdip" != "$myip" ] && [ "$myip" != "" ]; then
  echo "IP has changed!! Updating on Cloudflare"
  curl -X PUT \
    https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records/$dns_record_id \
    -H "Authorization: Bearer $api_token" \
    --data "{\"content\": \"$myip\",\"name\": \"$domain\",\"proxied\": false,\"type\": \"A\",\"comment\": \"Dynamic DNS\",\"ttl\": 600}"
  logger -p $logdest "Changed IP on gader.cc from ${gdip} to ${myip}"
fi