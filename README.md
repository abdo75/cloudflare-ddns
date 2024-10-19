# cloudflare-ddns
A bash script that lets you update a DNS record on Cloudflare via its API.

## Dynamic DNS Update Script

This script updates the Cloudflare DNS record for a domain to match your current external IP address. It compares the current external IP of your machine with the IP registered in the DNS record and updates Cloudflare if the IPs don't match. The script logs this operation using the system logger.

### Prerequisites

- **Curl**: Ensure `curl` is installed on your system.
- **jq**: Install `jq` for parsing JSON responses.
- **Cloudflare API Credentials**: You'll need your Cloudflare **API Token**, **zone ID**, **DNS record ID**, and **account email**.
- **System Logging**: The script logs changes to the system log under `local7.info`. You can modify this as needed.

### Setup

1. **Install `curl` and `jq`:**
    ```bash
    sudo apt update
    sudo apt install curl jq
    ```

2. **Cloudflare API Setup:**
   - Go to your [Cloudflare dashboard](https://dash.cloudflare.com/).
   - Get your **API Token** (must have permission to edit DNS records).
   - Retrieve your **Zone ID** and **DNS Record ID** from your DNS settings.
   
3. **Edit the Script:**
   Replace the placeholders in the script with your actual data:
   - `{zone_id}`: Your Cloudflare zone ID.
   - `{dns_record_id}`: The DNS record ID you want to update.
   - `API_EMAIL`: Your Cloudflare account email.
   - `API_TOKEN`: Your Cloudflare API key.
   - `domain.tld`: Replace with your domain if different.

### How the Script Works

1. The script fetches your external IP using `curl` from the [ipify service](https://api.ipify.org).
2. It fetches the current IP in Cloudflare DNS using Cloudflare's API.
3. If the two IPs do not match, it updates the Cloudflare DNS record with the new IP.
4. It logs the change to your system's log using `logger`.

### Example Usage

Run this script manually or set it as a cron job for periodic checks and updates.
Make sure you have execute permission.

#### Running the script:
```bash
./dns-update.sh
```

#### Automating with cron:
To run this every 5 minutes:
```bash
crontab -e
```
Add the following line:
```bash
*/5 * * * * /path/to/your/script/dns-update.sh
```

### Logging

The script logs IP changes to the system log. You can check the logs with:
```bash
tail -f /var/log/syslog
```

### Notes

- Ensure the IP and DNS record are properly formatted and that your Cloudflare account has sufficient permissions to make changes.
- Adjust the TTL (Time to Live) in the Cloudflare update request if necessary. The default is set to 600 seconds (10 minutes).

### License

This script is free to use and modify as needed. No warranty is provided.