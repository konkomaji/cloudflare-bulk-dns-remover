#!/bin/bash

# Check if jq is installed
if ! command -v jq &> /dev/null
then
    echo "jq could not be found. Please install it using your package manager."
    exit
fi

# Replace these variables with your actual email, API key, and zone ID
EMAIL="your_email@example.com"
KEY="your_api_key"
ZONE_ID="your_zone_id"

# Get all DNS records for the domain
all_records=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" \
    -H "X-Auth-Email: $EMAIL" \
    -H "X-Auth-Key: $KEY" \
    -H "Content-Type: application/json")

# Extract NS records and delete them
echo "$all_records" | jq -r '.result[] | select(.type == "NS") | .id' | while read id; do
    echo "Deleting NS record with ID: $id"
    curl -X DELETE "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$id" \
        -H "X-Auth-Email: $EMAIL" \
        -H "X-Auth-Key: $KEY" \
        -H "Content-Type: application/json"
done