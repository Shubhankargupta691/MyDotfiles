#!/bin/bash

# Check if target URL is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <target_url>"
    exit 1
fi

TARGET=$1
OUTPUT_DIR="ferox_results"
mkdir -p "$OUTPUT_DIR"

# --- CONFIGURATION ---

FILTERS="-s 200,301,302"
EXTENSIONS="php,html,txt,bak"

WORDLISTS=(
    "/usr/share/wordlists/dirb/common.txt"
    "/usr/share/wordlists/dirb/big.txt"
    "/usr/share/dirbuster/wordlists/directory-list-2.3-medium.txt"
    "/usr/share/wordlists/SecLists/Discovery/Web-Content/raft-large-files.txt"
    "/usr/share/wordlists/SecLists/Discovery/Web-Content/DirBuster-2007_directory-list-2.3-big.txt"
)
# ---------------------

echo "[*] Starting feroxbuster against $TARGET"

for wl in "${WORDLISTS[@]}"; do
    if [ -f "$wl" ]; then
        WL_NAME=$(basename "$wl")
        echo "[+] Running with wordlist: $WL_NAME"
        
        # Execute feroxbuster with corrected flags
        feroxbuster -u "$TARGET" \
                    -w "$wl" \
                    -o "$OUTPUT_DIR/results_${WL_NAME%.*}.txt" \
                    --json \
                    -t 100 \
                    -k \
                    -x "$EXTENSIONS" \
                    $FILTERS
    else
        echo "[!] Warning: Wordlist not found: $wl"
    fi
done

echo "[*] All tasks complete. Results saved in $OUTPUT_DIR/"
