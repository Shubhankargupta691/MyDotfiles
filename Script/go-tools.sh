#!/usr/bin/env bash

set -e

echo "[+] Checking if Go is installed..."
if ! command -v go &> /dev/null; then
    echo "[!] Go is not installed. Please install Go first."
    exit 1
fi



# Apply immediately to this session
export GOPATH="${GOPATH:-$HOME/go}"
export PATH="$PATH:/usr/local/go/bin:$GOPATH/bin"


echo "[+] Go paths configured for current + future sessions."
echo

# -----------------------------
# Install Go tools
# -----------------------------
TOOLS=(
    "github.com/OJ/gobuster/v3@latest"
    "github.com/sensepost/gowitness@latest"
    "github.com/tomnomnom/assetfinder@latest"
    "github.com/tomnomnom/waybackurls@latest"
    "github.com/owasp-amass/amass/v3/...@latest"
    "github.com/projectdiscovery/dnsx/cmd/dnsx@latest"
    "github.com/projectdiscovery/httpx/cmd/httpx@latest"
    "github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
)

echo "[+] Installing tools..."
for TOOL in "${TOOLS[@]}"; do
    echo "----------------------------------------"
    echo "[+] Installing: $TOOL"
    go install -v "$TOOL"
done

# -----------------------------
# Verify installations
# -----------------------------
echo
echo "[+] Verifying installation..."
echo "========================================"

declare -A VERIFY_CMDS=(
    ["gobuster"]="gobuster --version"
    ["gowitness"]="gowitness --help"
    ["assetfinder"]="assetfinder -h"
    ["waybackurls"]="waybackurls -h"
    ["amass"]="amass -version"
    ["dnsx"]="dnsx -h"
    ["httpx"]="httpx -h"
    ["subfinder"]="subfinder -version"
)

for BIN in "${!VERIFY_CMDS[@]}"; do
    echo -n "[*] Checking $BIN: "
    if command -v "$BIN" &> /dev/null; then
        echo "INSTALLED ✔"
        ${VERIFY_CMDS[$BIN]} 2>/dev/null | head -n 1
    else
        echo "NOT FOUND ✖"
    fi
    echo "----------------------------------------"
done

echo "[+] All done!"
