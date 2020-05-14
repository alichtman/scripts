#!/bin/bash
# This script does (highly opinionated) Linux setup on Ubuntu.
# Some of the git repos cloned below are private to @alichtman and will require access.
# Written by: Aaron Lichtman (@alichtman on GitHub)

# To run this script, use the following bash command:
# $ wget https://raw.githubusercontent.com/alichtman/scripts/master/setup/linux-setup.sh && chmod +x linux-setup.sh && ./linux-setup.sh

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

source ~/.zshenv
source ~/.config/zsh/.zshrc

# vim-plug for neovim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install nvim and plugins
sudo apt install neovim
nvim '+PlugUpdate' '+PlugUpgrade' '+CocUpdate' '+qall'

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

sudo apt install -y ddgr fzf g++ gcc git git-extras htop hub latte-dock libclang-dev libjansson-dev make neofetch plymouth polybar ranger silversearcher-ag spotify-client tmux xsel yq

# Install node
snap install --edge --classic node

# Install lsd
sudo snap install lsd

# Install ctags for Vista.vim
mkdir ~/open-source-software
git clone https://github.com/universal-ctags/ctags.git --depth=1 ~/open-source-software/ctags
cd ~/open-source-software/ctags || exit
./autogen.sh
./configure
make
sudo make install
cd ~ || exit

# tmux setup
mkdir ~/.config/tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
# Install tpm packages
~/.config/tmux/plugins/tpm/bin/install_plugins

# Install diff-so-fancy and prettyping
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

cargo install ripgrep bat fd-find starship

echo -e "## Setup Complete"
echo -e "## Rememer to install the fonts you want to use!"
