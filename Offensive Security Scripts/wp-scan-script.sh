#!/bin/bash

# Check if a target is provided
if [ -z "$1" ]; then
    echo "Usage: ./wp_enum.sh <URL>"
    echo "Example: ./wp_enum.sh http://backdoor.htb/blog"
    exit 1
fi

TARGET=$1
OUTPUT_FILE="WP-Scan.txt"

echo "[+] Starting aggressive scan on $TARGET..."
echo "[+] Results will be saved to $OUTPUT_FILE"

# The command with output redirection
# --no-update is critical for the exam environment (no internet)
# --no-banner keeps the text file clean for grep/parsing
sudo wpscan --url "$TARGET" \
    --enumerate u1-50,vp,vt,tt,cb,dbe \
    --plugins-detection aggressive \
    --themes-detection aggressive \
    --random-user-agent \
    --no-update \
    --no-banner \
    | tee "$OUTPUT_FILE"

echo "--------------------------------------------------"
echo "[+] Done! You can now analyze results with: cat $OUTPUT_FILE"
