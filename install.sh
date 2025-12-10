#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}[*] OSCP Toolkit Installer${NC}"
echo -e "${GREEN}[*] Setting Up Directories${NC}"

echo -e "${GREEN}[*] Specify the user ${NC}"
KALI_USER="/home/kali"
ROOT_USER="/root"

########################################
# Installing Essentials
########################################

echo -e "${GREEN}[*] Installing Essentials ${NC}"

sudo apt update && apt upgrade -y
sudo apt install -y massdns
sudo apt install -y dnsutils
sudo apt install -y dotdotpwn
sudo apt install -y sublist3r
sudo apt install -y knockpy
sudo apt install -y fierce
sudo apt install -y neovim
sudo apt install -y caido
sudo apt install -y obsidian
sudo apt install -y zaproxy
sudo apt install -y tmux
sudo apt install -y terminator
sudo apt install -y rlwrap
sudo apt install -y socat
sudo apt install -y zsh
sudo apt install -y bloodhound
sudo apt install -y villain
sudo apt install -y hoaxshell
sudo apt install -y remmina
sudo apt install -y fonts-jetbrains-mono
sudo apt install -y docker-cli docker-compose docker.io 

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
sudo chmod 666 /var/run/docker.sock

echo -e "${GREEN}[*]  Enable and start Docker Done ${NC}"

echo -e "${GREEN}[*]  Pulling Rust Scan Image ${NC}"
docker pull rustscan/rustscan
echo -e "${GREEN}[*]  Pulling Rust Scan Image Done ${NC}"

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
wget -P "$HOME/Downloads" --content-disposition \
    "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"

echo -e "${GREEN}[*] Installing VS Code... ${NC}"

DEB_FILE=$(ls -t "$HOME"/Downloads/code*.deb | head -n1)

# Check if a file was found
if [ -z "$DEB_FILE" ]; then
    echo "[!] No VS Code .deb file found in ~/Downloads"
    exit 1
fi

echo -e "${GREEN}[*] Installing $DEB_FILE... ${NC}"
sudo dpkg -i "$DEB_FILE"
echo -e "${GREEN}[*] Installed Complete... ${NC}"




########################################
# Install oh-my-zsh
########################################
echo -e "${GREEN}[*] Installing oh-my-zsh ${NC}"

chmod +x Script/ZSH.sh
./Script/ZSH.sh
sudo HOME=/root ./Script/ZSH.sh

echo -e "${GREEN}[*] copying .zshrc to root directory completed ${NC}"


########################################
# Install Go (for normal & root user)
########################################
# GO-Lang
echo -e "${GREEN}[*] Installing Go Lang ${NC}"

GO_VERSION="1.25.3"
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


echo -e "${GREEN}[*]  PATH updated in $USER_RC and $ROOT_RC ${NC}"
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.zshrc
echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee -a /root/.zshrc

echo -e "${GREEN}[*]  Go $GO_VERSION installation complete! ${NC}"
go version
echo -e "${GREEN}[*]  Go-Lang Installed ${NC}"




########################################
# Install Go-Lang Tools
########################################

echo -e "${GREEN}[*]  Installing Go-Lang Tools  ${NC}"

chmod +x Script/go-tools.sh
./Script/go-tools.sh

########################################
# Extract RockYou.txt
########################################
echo -e "${GREEN}[*]  unzip rockyou.txt... ${NC}"
sudo gunzip /usr/share/wordlists/rockyou.txt.gz

# Ensure ~/.config exists
if [ ! -d "$HOME/.config" ]; then
    echo "$HOME/.config not found — creating it."
    mkdir -p "$HOME/.config"
fi

########################################
# Setting up Dotfiles
########################################
echo -e "${GREEN}[*] Setting up Dotfiles ${NC}"

cp Config_File/.nanorc $HOME/.nanorc
echo -e "${GREEN}[*] copy .nanorc completed ${NC}"

cp Config_File/.vimrc $HOME/.vimrc
echo -e "${GREEN}[*] copy .vimrc completed ${NC}"

cp Config_File/.tmux.conf $HOME/.tmux.conf
echo -e "${GREEN}[*] copy .tmux.conf completed ${NC}"

echo -e "${GREEN}[*] Creating TMUX session to Load tmux config file ${NC}"
tmux new -s default -d
tmux source-file ~/.tmux.conf

echo -e "${GREEN}[*] Killing TMUX SERVER RUNNING check if there is any error on Line=203 tmux config completed ${NC}"
tmux kill-server
echo -e "${GREEN}[*] Load tmux config completed ${NC}"

echo -e "${GREEN}[*] chmod +x Script/Local_IP.sh completed ${NC}"
chmod +x Script/xfce4-panel-genmon-Local_IP.sh
sudo cp Script/xfce4-panel-genmon-Local_IP.sh /usr/share/kali-themes/xfce4-panel-genmon-Local_IP.sh
echo -e "${GREEN}[*] copy Local_IP.sh completed ${NC}"

echo -e "${GREEN}[*] chmod +x Script/vpn-ip.sh completed ${NC}"
chmod +x Script/xfce4-panel-genmon-vpnip.sh
sudo  cp Script/xfce4-panel-genmon-vpnip.sh /usr/share/kali-themes/xfce4-panel-genmon-vpnip.sh
echo -e "${GREEN}[*] copy vpn-ip.sh completed ${NC}"


########################################
# Python Virtual Environment Setup
########################################
echo -e "${GREEN}[*] Running the create_py_envs Script to create an virtual environment${NC}"
chmod +x Script/create_py_envs.sh
./Script/create_py_envs.sh

echo -e "${GREEN}[*] Python Virtual Environment Setup for Root ${NC}"
sudo ./Script/create_py_envs.sh
echo -e "${GREEN}[*] Python Virtual Environment Setup Complete${NC}"

########################################
# Configure Neovim
########################################
echo -e "${GREEN}[*] Setting up Neovim${NC}"

# Create nvim folder
mkdir -p "$HOME/.config/nvim"
echo "Created: $HOME/.config/nvim"

# Move init.lua if it exists
if [ -f "init.lua" ]; then
    cp Config_File/init.lua "$HOME/.config/nvim/init.lua"
    echo "Moved init.lua to $HOME/.config/nvim/init.lua"
else
    echo "init.lua not found in the current directory — skipping move."
fi
echo -e "${GREEN}[*] Neovim setup complete${NC}"


########################################
# Configure Terminator
########################################

echo -e "${GREEN}[*] creating Terminator${NC}"
# Create terminator folder
mkdir -p "$HOME/.config/terminator"
echo "Created: $HOME/.config/terminator"

cp Config_File/terminator_config $HOME/.config/terminator/config
echo -e "${GREEN}[*] Terminator config copied ${NC}"

########################################
# SecLists
########################################
echo -e "${GREEN}[*]  Setting SecLists  ${NC}"

# Default path for SecLists
SECLISTS_PATH="/usr/share/wordlists/SecLists" 

if [[ -d "$SECLISTS_PATH" ]]; then
    echo -e "${GREEN}[+] SecLists directory found at $SECLISTS_PATH.${NC}"
else
    echo -e "${GREEN}[*] SecLists directory not found at $SECLISTS_PATH. ${NC}"
    read -p "Do you want to download SecLists? y/n " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo -e "${GREEN}[*] Downloading SecLists${NC}"
        cd /usr/share/wordlists/
        sudo git clone --depth 1 https://github.com/danielmiessler/SecLists.git
        
        if [[ -d "$SECLISTS_PATH" ]]; then
            echo -e "${GREEN}[+] SecLists successfully cloned to $SECLISTS_PATH.${NC}"
        else
            echo -e "${RED}[!] Cloning failed. Please check your internet connection or permissions.${NC}"
        fi
    else
        echo -e "${RED}[-] Skipping SecLists download.${NC}"     
        
    fi
fi

echo -e "${GREEN}[*]  Cloning Complete  ${NC}"


########################################
# Final Message
########################################

echo -e "${GREEN}[*] Installation Complete! ${NC}"

