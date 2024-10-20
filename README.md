# cloudflare-ddns
This script updates the Cloudflare DNS record for a domain to match your current external IP address. It compares the current external IP of your machine with the IP registered in the DNS record and updates Cloudflare if the IPs don't match. The script logs this operation using the system logger.

## Prerequisites

- Ensure `curl` and `jq` are installed on your system.
- You'll need your Cloudflare **API Token**, **zone ID**, **DNS record ID**.

## Setup

1. **Install `curl` and `jq`:**
    ```bash
    sudo apt update
    sudo apt install curl jq
    ```

2. **Cloudflare API Setup:**
   - Go to your [Cloudflare dashboard](https://dash.cloudflare.com/).
   - Create an **API Token** (must have permission to edit DNS records).
   - Retrieve your **Zone ID** from the overview section 
   - Select a DNS record and fetch its **DNS Record ID** (Find it by running the following script)

   ```bash
   api_token="API_TOKEN"
   curl --request GET \
   https://api.cloudflare.com/client/v4/zones/1234567890abcdef/dns_records/abcdef1234567890 \
   -H "Authorization: Bearer $api_token" | jq -r '.result.content'
   ```
   
3. **Edit the Script:**
   Replace the placeholders in the script with your actual data:
   - `domain`
   - `zoneid`
   - `api_token`
   - `dns_record_id`

## Example Usage

Run this script manually or set it as a cron job for periodic checks and updates.
Make sure you have execute permission.

```bash
./dns-update.sh
```

## Automating with cron:
To run this every 5 minutes:
```bash
crontab -e
```
Add the following line:
```bash
*/5 * * * * /path/to/your/script/dns-update.sh
```

## Logging

The script logs IP changes to the system log. You can check the logs with:
```bash
tail -f /var/log/syslog
```

## Notes

- Adjust the TTL (Time to Live) in the Cloudflare update request if necessary. The default is set to 600 seconds (10 minutes).

## License

This script is free to use and modify as needed. No warranty is provided.