#!/bin/bash

# Configuration variables
logdest="local7.info"
domain="example.com"
zone_id="ZONE_ID"
api_token="API_TOKEN"
dns_record_id="DNS_RECORD_ID"

# Get the current public IP address
myip=$(curl -s "https://api.ipify.org")

# Get the current IP address set in Cloudflare DNS
gdip=$(curl -s -X GET \
  "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records/$dns_record_id" \
  -H "Authorization: Bearer $api_token" \
  -H "Content-Type: application/json" | jq -r ".result.content")

# Log the current state
echo "$(date '+%Y-%m-%d %H:%M:%S') - Current External IP is $myip, Cloudflare DNS IP is $gdip"

# Update the DNS record if the IPs don't match
if [[ "$gdip" != "$myip" && "$myip" != "" ]]; then
  echo "IP has changed!! Updating on Cloudflare"
  
  update_response=$(curl -s -X PUT \
    "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records/$dns_record_id" \
    -H "Authorization: Bearer $api_token" \
    -H "Content-Type: application/json" \
    --data "{\"content\": \"$myip\", \"name\": \"$domain\", \"proxied\": false, \"type\": \"A\", \"ttl\": 600}")

  # Check the response for success
  success=$(echo "$update_response" | jq -r ".success")
  if [[ "$success" == "true" ]]; then
    echo "Successfully updated Cloudflare DNS record."
    logger -p $logdest "Changed IP on $domain from ${gdip} to ${myip}"
  else
    echo "Failed to update Cloudflare DNS record: $update_response"
    logger -p $logdest "Failed to update IP on $domain. Response: $update_response"
  fi
else
  echo "No update needed. Current IP ($myip) matches Cloudflare DNS IP ($gdip)."
  logger -p $logdest "No update performed. Current IP matches DNS IP for $domain."
fi

