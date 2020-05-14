#!/bin/bash
# This script does (highly opinionated) Linux setup on Ubuntu.
# Some of the git repos cloned below are private to @alichtman and will require access.
# Written by: Aaron Lichtman (@alichtman on GitHub)

# To run this script, use the following bash command:
# $ wget https://raw.githubusercontent.com/alichtman/scripts/master/setup/linux-setup.sh && chmod +x linux-setup.sh && ./linux-setup.sh

# TODO: Better debug output
#       Clean up package installs
#       Function to download latest GitHub release: https://www.google.com/search?hl=en&q=curl%20latest%20github%20release%20deb

error() {
  printf '\E[31m'; echo "$@"; printf '\E[0m'
}

if [[ $(uname -s) != "Linux" ]]; then
    error "ERROR: OS is not Linux!"
    exit 1
fi

if [[ $EUID -eq 0 ]]; then
    error "Must NOT be root user"
    exit 1
fi

sudo apt install software-properties-common curl
sudo apt-add-repository multiverse
sudo apt-add-repository universe
sudo apt-add-repository main
sudo apt-add-repository restricted
sudo apt-add-repository "deb http://archive.canonical.com/ubuntu $(lsb_release -sc) partner"

echo "Have you added contrib and non-free to the /etc/apt/sources.list file?"
echo "    -> https://wiki.debian.org/SourcesList"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) echo "Continuing."; break;;
        No ) exit;;
    esac
done


# Gen new SSH key
echo "Place this key at ~/.ssh/alichtman-GitHub, and upload the public key to GitHub"
ssh-keygen -t rsa -b 4096 -C "aaronlichtman@gmail.com"

echo "Have you added the public key to GitHub?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) break;;
    esac
done

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/alichtman-GitHub

sudo apt-update

# zsh
sudo apt install zsh -y
echo "Changing shell to zsh"
chsh -s "$(command -v zsh)"

sudo apt install python3-pip -y
export PATH="$PATH:$HOME/.local/bin"
pip3 install shallow-backup pynvim thefuck

# shallow-backup + dotfiles
mkdir ~/shallow-backup
git clone https://github.com/alichtman/dotfiles ~/shallow-backup/dotfiles
cp ~/shallow-backup/dotfiles/.config/shallow-backup.conf ~/.config
shallow-backup -reinstall-dots
# Will reclone later with SSH so I can use it as a git repo
rm -rf ~/shallow-backup/dotfiles

source "$HOME"/.zshenv
source "$HOME"/.config/zsh/.zshrc

# vim-plug for neovim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install nvim and plugins
sudo apt install neovim
nvim '+PlugUpdate' '+PlugUpgrade' '+CocUpdate' '+qall'

# Install ctags for Vista.vim
sudo snap install universal-ctags
sudo snap connect universal-ctags:dot-ctags

# zinit
mkdir ~/.config/zsh/.zinit
git clone https://github.com/zdharma/zinit.git ~/.config/zsh/.zinit/bin

# install yq
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CC86BB64
sudo add-apt-repository ppa:rmescandon/yq

# install spotify
curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

sudo apt update

sudo apt install -y \
    ddgr \
    fzf \
    g++ \
    gcc \
    git \
    git-extras \
    htop \
    hub \
    latte-dock \
    libclang-dev \
    libjansson-dev \
    libssl-dev \
    make \
    neofetch \
    openssh-server \
    plymouth \
    polybar \
    ranger \
    silversearcher-ag \
    spotify-client \
    steam \
    chromium-browser \
    tmux \
    xsel \
    yq \

# Install node
sudo snap install --edge --classic node

# Install PyCharm and CLion
sudo snap install pycharm-community --classic
sudo snap install clion --classic

# Install Signal Desktop
curl -s https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add -
# Yeah, I know xenial is weird here... It works though.
echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
sudo apt update && sudo apt install signal-desktop

# Install Discord
wget -O discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
sudo dpkg -i discord.deb
rm discord.deb

# Install Caprine
sudo snap install caprine

# Install VSCode
sudo snap install --classic code

mkdir ~/open-source-software

# tmux setup
mkdir ~/.config/tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
# Install tpm packages
~/.config/tmux/plugins/tpm/bin/install_plugins

# Install diff-so-fancy and prettyping
mkdir ~/bin
curl https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy -o ~/bin/diff-so-fancy && chmod +x ~/bin/diff-so-fancy
curl https://raw.githubusercontent.com/denilsonsa/prettyping/master/prettyping -o ~/bin/prettyping && chmod +x ~/bin/prettyping

# Clone my repos
mkdir ~/Desktop/Development
git clone --recursive git@github.com:alichtman/notes.git ~/Desktop/Development/notes
git clone git@github.com:alichtman/writeups.git ~/Desktop/Development/writeups
git clone git@github.com:alichtman/scripts.git ~/Desktop/Development/scripts
git clone git@github.com:alichtman/fzf-notes.git ~/Desktop/Development/fzf-notes
git clone git@github.com:alichtman/dotfiles.git ~/shallow-backup/dotfiles

# Install my scripts
mkdir ~/bin
(cd ~/Desktop/Development/fzf-notes && chmod +x fzf-notes && ln -s "$(realpath fzf-notes)" ~/bin/fzf-notes)
(cd ~/Desktop/Development/scripts && chmod +x INSTALL.sh && ./INSTALL.sh)

# Install fonts with glyph support
# TODO: Actually install the font
git clone git@github.com:alichtman/patched-nerd-fonts.git ~/Desktop/Development/patched-nerd-fonts

# Install cargo
curl https://sh.rustup.rs -sSf | sh

cargo install ripgrep bat fd-find starship lsd

# Set up ssh
sudo ufw allow ssh

rm ~/.bashrc ~/.bash_history ~/.bash_logout ~/.sudo_as_admin_successful ~/.wget-hsts

echo -e "## Setup Complete"
echo -e "## Remember to install the fonts you want to use!"
echo -e "## Remember to add SSH keys and disable password-based logins!"
