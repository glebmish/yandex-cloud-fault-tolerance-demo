#!/bin/bash

IG_ID="$1"
if [[ -z "$IG_ID" ]]; then
    echo "please provide id of Instance Group as the first argument"
    exit 1
fi

# IP addresses of instances
ADDRESSES=( $(yc compute instance-group list-instances "$IG_ID" --format json | jq -r ".[].network_interfaces[0].primary_v4_address.one_to_one_nat.address") )
# Seed random generator
RANDOM=$$$(date +%s)

selected=${ADDRESSES[$RANDOM % ${#ADDRESSES[@]} ]}
echo $selected is selected

curl -s -X POST "$selected/switch_healthy" >/dev/null
if [[ $? == 0 ]]; then
    echo "$selected is now broken"
else
    echo "failed to break $selected"
fi
