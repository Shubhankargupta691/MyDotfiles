#!/bin/sh

get_active_iface() {
  ip route | grep '^default' | awk '{print $5}' | head -n1 || \
  ip link | awk -F: '$0 !~ "lo|vir|docker|^[^0-9]"{print $2;getline}' | head -n1 | tr -d ' '
}

interface="$1"
[ -z "$interface" ] && interface="$(get_active_iface)"

ip="$(ip addr show "$interface" 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')"

if [ -n "$ip" ]; then
  printf "<icon>network-vpn-symbolic</icon>\n"
  printf "<txt>%s</txt>\n" "$ip"
  if command -v xclip >/dev/null; then
    printf "<iconclick>sh -c 'printf %s | xclip -selection clipboard'</iconclick>\n" "$ip"
    printf "<txtclick>sh -c 'printf %s | xclip -selection clipboard'</txtclick>\n" "$ip"
    printf "<tool>Local_IP (click to copy)</tool>\n"
  else
    printf "<tool>Local_IP (install xclip to copy to clipboard)</tool>\n"
  fi
else
  printf "<txt></txt>\n"
fi
