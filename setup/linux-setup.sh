#!/bin/bash
# This script does basic linux setup

# zsh
sudo apt install zsh
chsh -s "$(which zsh)"

# oh-my-zsh

[ -d ~/.oh-my-zsh ] || sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Maybe a good time to restart?"

# shallow-backup + dotfiles
pip3 install shallow-backup>=4.0.1

mkdir ~/shallow-backup
git clone https://github.com/alichtman/dotfiles ~/shallow-backup/dotfiles
mv ~/shallow-backup/dotfiles/.config/shallow-backup.conf ~/.config
shallow-backup


# vim-plug for neovim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Start vim and install plugins
nvim '+PlugUpdate' '+PlugUpgrade' '+CocUpdate' '+qall'

# zinit
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
# shellcheck disable=SC1090
source "$HOME/.zshrc"

sudo apt-get install ctags ranger fzf silversearcher-ag
sudo apt install hub xsel ddgr

# Gen new SSH key
echo "Place this key at /home/alichtman/.ssh/alichtman-GitHub"
ssh-keygen -t rsa -b 4096 -C "aaronlichtman@gmail.com"

# Install lsd
curl https://github.com/Peltoche/lsd/releases/download/0.16.0/lsd_0.16.0_amd64.deb -o ~/Downloads/lsd.deb
sudo dpkg -i ~/Downloads/lsd.deb

# Install tls
mkdir ~/bin
curl https://raw.githubusercontent.com/alichtman/scripts/master/tls.sh -o ~/bin/tls
chmod +x ~/bin/tls

# tmux setup
ln -s ~/.tmux/tmux.conf ~/.tmux.conf
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
echo "Prefix + I to install plugins"

# install diff-so-fancy
curl https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy -o ~/bin/diff-so-fancy
chmod +x ~/bin/diff-so-fancy

# clone important repos
mkdir ~/Desktop/Development
git clone --recursive git@github.com:alichtman/notes.git ~/Desktop/Development/notes
git clone git@github.com:alichtman/writeups.git ~/Desktop/Development/writeups
git clone git@github.com:alichtman/scripts.git ~/Desktop/Development/scripts
git clone git@github.com:alichtman/fzf-notes.git ~/Desktop/Development/fzf-notes
(cd ~/Desktop/Development/fzf-notes && chmod +x fzf-notes && cp fzf-notes ~/bin/fzf-notes)

# install yq
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CC86BB64
sudo add-apt-repository ppa:rmescandon/yq
sudo apt update
sudo apt install yq -y

# Install Hack Nerd font
git clone --depth=1 git@github.com:ryanoasis/nerd-fonts.git /tmp/nerd-fonts
(cd /tmp/nerd-fonts && ./install.sh Hack)
rm -rf /tmp/nerd-fonts
echo "WARN: Manual installation of Nerd Fonts required."
xdg-open ~/.local/share/fonts/


# Install latte-dock
# sudo add-apt-repository ppa:rikmills/latte-dock
# sudo apt update
# sudo apt install latte-dock

# Install backup tool
sudo apt-get install deja-dup

# Install cargo
curl https://sh.rustup.rs -sSf | sh

cargo install ripgrep


pip3 install pynvim

curl https://raw.githubusercontent.com/denilsonsa/prettyping/master/prettyping -o ~/bin/prettyping
chmod +x ~/bin/prettyping

pip3 install thefuck
