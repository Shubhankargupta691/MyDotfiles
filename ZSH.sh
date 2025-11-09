#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}[*] Installing oh-my-zsh ${NC}"
# Prevent the installer from automatically switching the login shell or
# starting a new zsh session so the rest of this script continues running
# in the current shell. The installer respects RUNZSH and CHSH env vars.
RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo -e "${GREEN}[*] Installing oh-my-zsh Complete ${NC}"


echo -e "${GREEN}[*] Installing oh-my-zsh Custom Plugins ${NC}"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/jhwohlgemuth/zsh-pentest.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-pentest
echo -e "${GREEN}[*] Installing oh-my-zsh Custom Plugins Completed ${NC}"

echo -e "${GREEN}[*] Installing oh-my-zsh Custom web-search in $HOME Plugins ${NC}"
chmod +x web-search.sh
mv web-search.sh $HOME/.oh-my-zsh/custom/plugins/web-search/web-search.sh
echo -e "${GREEN}[*] Installing oh-my-zsh Custom web-search in $HOME Plugins Done ${NC}"

echo -e "${GREEN}[*] Removing the default .zshrc file ${NC}" 
rm -f $HOME/.zshrc
echo -e "${GREEN}[*] copying .zshrc file to $HOME Directory ${NC}"
cp Config_File/.zshrc $HOME/.zshrc
# Only source .zshrc if we're currently running zsh. Sourcing a zsh rc
# from bash can cause syntax errors because .zshrc contains zsh-specific
# syntax. If the current shell isn't zsh, print instructions instead.
if [ -n "$ZSH_VERSION" ] || [ "$(basename "$SHELL")" = "zsh" ]; then
	echo -e "${GREEN}[*] Sourcing .zshrc in current zsh session ${NC}"
	# shellcheck disable=SC1090
	source "$HOME/.zshrc"
fi
echo -e "${GREEN}[*] copying .zshrc completed ${NC}"

echo -e "${GREEN}[*] Run as Root to install this in root ${NC}"
