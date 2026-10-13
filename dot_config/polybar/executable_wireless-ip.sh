#!/bin/sh

interface=$(awk 'NR > 2 && $1 != "" { sub(/:$/, "", $1); print $1; exit }' /proc/net/wireless 2>/dev/null)
if [ -z "$interface" ] && command -v iw >/dev/null 2>&1; then
    interface=$(iw dev 2>/dev/null | awk '$1 == "Interface" { print $2; exit }')
fi
if [ -z "$interface" ]; then
    interface=$(ip -o link show 2>/dev/null | awk -F': ' '$2 ~ /^(wl|wifi)/ { sub(/@.*/, "", $2); print $2; exit }')
fi
if [ -z "$interface" ]; then
    notify-send "Wireless IP" "No wireless interface found"
    exit 0
fi
address=$(ip -4 -o addr show dev "$interface" scope global 2>/dev/null | awk 'NR == 1 { print $4 }')
if [ -z "$address" ]; then
    address="No IPv4 address"
fi
notify-send "Wireless IP ($interface)" "$address"
