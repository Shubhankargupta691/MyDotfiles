#!/bin/bash

# Check if target URL is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <target_url> "
    exit 1
fi

TARGET=$1
OUTPUT_DIR="ffuf_results"
mkdir -p "$OUTPUT_DIR"

# --- CONFIGURATION ---
# Define your filters here. 
# Examples: 
# "-fc 403,404" (Filter codes 403 and 404)
# "-fs 1234" (Filter response size 1234)
# "-fw 10" (Filter response word count 10)
FILTERS=" -mc 200,301,302 -fc 403,404"

# List your wordlists
WORDLISTS=(
    "/usr/share/wordlists/dirb/common.txt"
    "/usr/share/wordlists/dirb/big.txt"
    "/usr/share/dirbuster/wordlists/directory-list-2.3-medium.txt"
    "/usr/share/wordlists/SecLists/Discovery/Web-Content/raft-large-files.txt"
)
# ---------------------

echo "[*] Starting ffuf against $TARGET"

for wl in "${WORDLISTS[@]}"; do
    if [ -f "$wl" ]; then
        WL_NAME=$(basename "$wl")
        echo "[+] Running with wordlist: $WL_NAME"
        
        # Execute ffuf with variable filters
        ffuf -ic -u "$TARGET/FUZZ" \
             -w "$wl" \
             -o "$OUTPUT_DIR/results_${WL_NAME%.*}.json" \
             -ac \
             -t 100 \
             $FILTERS
    else
        echo "[!] Warning: Wordlist not found: $wl"
    fi
done

echo "[*] All tasks complete. Results saved in $OUTPUT_DIR/"