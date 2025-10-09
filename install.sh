#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}[*] Bug Bounty Toolkit Installer${NC}"
echo -e "${GREEN}[*] Setting Up Directories${NC}"

cd $HOME



########################################
# Installing Essentials
########################################

echo -e "${GREEN}[*] Installing Essentials ${NC}"

apt update && apt upgrade -y
apt install -y massdns
apt install -y dnsutils
apt install -y dotdotpwn
apt install -y sublist3r
apt install -y knockpy
apt install -y fierce
apt install -y neovim
apt install -y caido
apt install -y obsidian
apt install -y zaproxy
apt install -y tmux
apt install fonts-jetbrains-mono
apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo -e "${GREEN}[*] Essentials installed${NC}"


########################################
# Setting UP Docker
########################################

echo -e "${GREEN}[*]  Enable and start Docker ${NC}"
# Enable and start Docker
sudo systemctl enable docker
sudo systemctl start docker

sudo groupadd docker || true    # ensure group exists
sudo usermod -aG docker $USER   # add user to group

echo -e "${GREEN}[*]  Enable and start Docker Done ${NC}"





########################################
# Install Brave Browser
########################################
echo -e "${GREEN}[*] Installing Brave Browser... ${NC}"
curl -fsS https://dl.brave.com/install.sh | sh
echo -e "${GREEN}[*] Installed Complete... ${NC}"



########################################
# Install VS-CODE
########################################
echo -e "${GREEN}[*] Installing VS Code... ${NC}"
if command -v code >/dev/null 2>&1; then
    OLD_PATH=$(command -v code)
    echo "[*] Removing old VS Code binary at $OLD_PATH..."
    sudo rm -f "$OLD_PATH"
fi

echo -e "${GREEN}[*]  Downloading latest VS Code... ${NC}"
wget --content-disposition \
    "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"

echo -e "${GREEN}[*] Installing VS Code... ${NC}"

DEB_FILE=$(ls -t "$HOME"/Downloads/code*.deb | head -n1)

# Check if a file was found
if [ -z "$DEB_FILE" ]; then
    echo "[!] No VS Code .deb file found in ~/Downloads"
    exit 1
fi

echo -e "${GREEN}[*] Installing $DEB_FILE... ${NC}"
dpkg -i "$DEB_FILE"
echo -e "${GREEN}[*] Installed Complete... ${NC}"



########################################
# Install Go (for normal & root user)
########################################
# GO-Lang
echo -e "${GREEN}[*] Installing Go Lang ${NC}"

GO_VERSION="1.25.1"
GO_URL="https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz"
GO_TAR="$HOME/Downloads/go${GO_VERSION}.linux-amd64.tar.gz"

echo -e "${GREEN}[*] Downloading Go $GO_VERSION... ${NC}"

mkdir -p "$HOME/Downloads"
wget -O "$GO_TAR" "$GO_URL"

echo -e "${GREEN}[*]  Remove old Go installation if exists ${NC}"
if [ -d "/usr/local/go" ]; then
    echo "[*] Removing old /usr/local/go directory"
    sudo rm -rf /usr/local/go
fi


echo -e "${GREEN}[*]  Extracting Go to /usr/local... ${NC}"
sudo tar -C /usr/local -xzf "$GO_TAR"

# Remove downloaded tar.gz
rm -f "$GO_TAR"

echo -e "${GREEN}[*] Remove downloaded tar.gz Done  ${NC}"


# Function to detect shell and determine rc file
get_rc_file() {
    local user_home=$1
    local shell_name
    shell_name=$(basename "$SHELL")
    if [ "$shell_name" = "zsh" ]; then
        echo "$user_home/.zshrc"
    elif [ "$shell_name" = "bash" ]; then
        echo "$user_home/.bashrc"
    else
        echo "$user_home/.profile"
    fi
}

# Update PATH for a given user and rc file
update_path() {
    local rc_file=$1
    local user_bin_dir=$2
    local go_path="/usr/local/go/bin:$user_bin_dir"

    if ! grep -q "$go_path" "$rc_file" 2>/dev/null; then
        echo "export PATH=\$PATH:$go_path" >> "$rc_file"
    fi
}

# Normal user
USER_RC=$(get_rc_file "$HOME")
update_path "$USER_RC" "$HOME/go/bin"

# Root user
ROOT_RC=$(get_rc_file "/root")
sudo bash -c "update_path \"$ROOT_RC\" \"/root/go/bin\"" 2>/dev/null || true

# Export for current session (normal user)
export PATH="/usr/local/go/bin:$HOME/go/bin:$PATH"

echo -e "${GREEN}[*]  Go $GO_VERSION installation complete! ${NC}"
go version

echo -e "${GREEN}[*]  PATH updated in $USER_RC and $ROOT_RC ${NC}"
echo -e "${GREEN}[*]  Go-Lang Installed ${NC}"




########################################
# Install Go-Lang Tools
########################################

echo -e "${GREEN}[*]  Installing Go-Lang Tools  ${NC}"

go install -v github.com/OJ/gobuster/v3@latest
go install -v github.com/sensepost/gowitness@latest
go install -v github.com/tomnomnom/assetfinder@latest
go install -v github.com/tomnomnom/waybackurls@latest
go install -v github.com/owasp-amass/amass/v3/...@latest
go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest




########################################
# Extract RockYou.txt
########################################
echo -e "${GREEN}[*]  unzip rockyou.txt... ${NC}"
gunzip /usr/share/wordlists/rockyou.txt.gz


########################################
# Setting up Dotfiles
########################################
echo -e "${GREEN}[*] Setting up Dotfiles ${NC}"
mv .nanorc $HOME/.nanorc
mv .tmux.conf $HOME/.tmux.conf
mv .vimrc $HOME/.vimrc




########################################
# Configure Neovim
########################################
echo -e "${GREEN}[*] Setting up Neovim${NC}"

# Ensure ~/.config exists
if [ ! -d "$HOME/.config" ]; then
    echo "$HOME/.config not found — creating it."
    mkdir -p "$HOME/.config"
fi

# Create nvim folder
mkdir -p "$HOME/.config/nvim"
echo "Created: $HOME/.config/nvim"

# Move init.lua if it exists
if [ -f "init.lua" ]; then
    mv init.lua "$HOME/.config/nvim/init.lua"
    echo "Moved init.lua to $HOME/.config/nvim/init.lua"
else
    echo "init.lua not found in the current directory — skipping move."
fi
echo -e "${GREEN}[*] Neovim setup complete${NC}"



# SecLists
echo -e "${GREEN}[*]  Cloning SecLists  ${NC}"
read -p "Do you want to download SecLists? y/n " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo -e "${GREEN}[*] Downloading SecLists${NC}"
    cd /usr/share/wordlists
    git clone --depth 1 https://github.com/danielmiessler/SecLists.git
fi

if [[ -d "$SECLISTS_PATH" ]]; then
    echo -e "${GREEN}[*] SecLists directory found at $SECLISTS_PATH. ${NC}"
else
    echo -e "${GREEN}[*] SecLists directory not found at $SECLISTS_PATH. ${NC}"
fi

echo -e "${GREEN}[*]  Cloning Complete  ${NC}"



########################################
# Final Message
########################################

echo -e "${GREEN}[*] Installation Complete! ${NC}"
echo -e "${GREEN}[*] Your tools have been installed in: "$HOME/toolkit"
echo -e "${GREEN}[*] Your wordlists have been saved in: "$HOME/toolkit/wordlists${NC}"