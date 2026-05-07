# #!/bin/sh

# interface="$1"

# [ -z "$interface" ] && interface="$(ip tuntap show | cut -d : -f1 | head -n 1)"
# ip="$(ip addr show "${interface}" 2>/dev/null \
#         | grep -o -P '(?<=inet )[0-9]{1,3}(\.[0-9]{1,3}){3}')"

# if [ "${ip}" != "" ]; then
#   printf "<icon>network-vpn-symbolic</icon>"
#   printf "<txt>${ip}</txt>"
#   if command -v xclip; then
#     printf "<iconclick>sh -c 'printf ${ip} | xclip -selection clipboard'</iconclick>"
#     printf "<txtclick>sh -c 'printf ${ip} | xclip -selection clipboard'</txtclick>"
#     printf "<tool>VPN IP (click to copy)</tool>"
#   else
#     printf "<tool>VPN IP (install xclip to copy to clipboard)</tool>"
#   fi
# else
#   printf "<txt></txt>"
# fi



#!/bin/sh
interface="$1"

if [ -n "$interface" ]; then
    # Single interface mode (original behaviour)
    ip="$(ip addr show "${interface}" 2>/dev/null \
        | grep -o -P '(?<=inet )[0-9]{1,3}(\.[0-9]{1,3}){3}')"
    ips="$ip"
else
    # Collect IPs from ALL tun interfaces
    ips="$(ip addr show \
        | awk '/^[0-9]+: tun/{iface=$2} iface && /inet /{print $2}' \
        | cut -d/ -f1 \
        | tr '\n' ' ' \
        | sed 's/ $//')"
fi

if [ -n "$ips" ]; then
    printf "<icon>network-vpn-symbolic</icon>"
    printf "<txt>%s</txt>" "$ips"
    if command -v xclip > /dev/null 2>&1; then
        first_ip="$(echo "$ips" | awk '{print $1}')"
        printf "<iconclick>sh -c 'printf %s | xclip -selection clipboard'</iconclick>" "$first_ip"
        printf "<txtclick>sh -c 'printf %s | xclip -selection clipboard'</txtclick>" "$first_ip"
        printf "<tool>VPN IPs: %s (click to copy first)</tool>" "$ips"
    else
        printf "<tool>VPN IPs: %s (install xclip to copy)</tool>" "$ips"
    fi
else
    printf "<txt></txt>"
fi
