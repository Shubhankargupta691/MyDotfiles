#!/bin/sh

interface="$(ip tuntap show | cut -d : -f1 | head -n 1)"
ip="$(ip a s "${interface}" 2>/dev/null \
        | grep -o -P '(?<=inet )[0-9]{1,3}(\.[0-9]{1,3}){3}')"

if [ "${ip}" != "" ]; then
  printf "<icon>network-vpn-symbolic</icon>"
  printf "<txt>${ip}</txt>"
  printf "<tool>VPN IP</tool>"
else
  printf "<txt></txt>"
fi
