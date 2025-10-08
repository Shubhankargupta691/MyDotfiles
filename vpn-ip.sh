#!/bin/bash
# vpn-ip.sh — Display VPN IP address in one line (terminal + popup)

# List of common VPN network interfaces Change it if its not the same on your system
interfaces=("tun0" "tun1" "wg0" "wg1" "ppp0" "tap0")

for iface in "${interfaces[@]}"; do
    if ip addr show "$iface" &>/dev/null; then
        ip_addr=$(ip -4 addr show "$iface" | awk '/inet / {print $2}' | cut -d'/' -f1)
        if [ -n "$ip_addr" ]; then
            msg="VPN: $iface | IP: $ip_addr"
            notify-send "VPN Connected" "$msg"
            echo "$msg"
            exit 0
        fi
    fi
done

msg="No VPN connection detected"
notify-send "VPN Status" "$msg"
echo "$msg"