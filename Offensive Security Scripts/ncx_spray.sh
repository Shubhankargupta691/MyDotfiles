#!/bin/bash

# Usage:
#   nxcspray <protocols|all> <targets> -u <username> -p <password>
#
# Examples:
#   nxcspray all 10.10.10.10 -u bob -p password
#   nxcspray smb,ldap,winrm hosts.txt -u bob -p password

# ---- Argument Validation ----
if [ "$#" -lt 4 ]; then
    echo "[-] Usage: $0 <protocols|all> <targets> -u <username> -p <password>"
    exit 1
fi

PROTOS_RAW="$1"
TARGETS_RAW="$2"
shift 2

USER=""
PASS=""

while getopts "u:p:" opt; do
    case $opt in
        u) USER="$OPTARG" ;;
        p) PASS="$OPTARG" ;;
        *)
            echo "[-] Invalid flag"
            exit 1
            ;;
    esac
done

if [ -z "$USER" ] || [ -z "$PASS" ]; then
    echo "[-] Missing required flags: -u <username> -p <password>"
    exit 1
fi

# ---- Protocol Handling ----
if [ "$PROTOS_RAW" = "all" ]; then
    PROTO_ARRAY=(smb ldap winrm rdp mssql ssh)
else
    IFS=',' read -ra PROTO_ARRAY <<< "$PROTOS_RAW"
fi

# ---- Target Handling ----
if [ -f "$TARGETS_RAW" ]; then
    TARGETS=$(cat "$TARGETS_RAW")
else
    TARGETS="$TARGETS_RAW"
fi

# ---- Spray Loop ----
for PROTO in "${PROTO_ARRAY[@]}"; do
    echo "[+] Spraying protocol: $PROTO"

    for TARGET in $TARGETS; do
        echo "    -> Target: $TARGET"
        nxc "$PROTO" "$TARGET" -u "$USER" -p "$PASS"
    done
done