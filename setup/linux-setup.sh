#!/bin/bash
# This script does basic linux setup

# shallow-backup + dotfiles
pip3 install shallow-backup>=4.0.1

mkdir ~/shallow-backup
git clone https://github.com/alichtman/dotfiles ~/shallow-backup/dotfiles
mv ~/shallow-backup/dotfiles/.config/shallow-backup.conf ~/.config
shallow-backup

# zsh
sudo apt install zsh
chsh -s $(which zsh)

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# vim-plug for neovim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# zinit
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"


sudo apt-get install ctags
sudo apt install hub xsel

# Gen new SSH key
echo "Place this key at /home/alichtman/.ssh/alichtman-GitHub"
ssh-keygen -t rsa -b 4096 -C "aaronlichtman@gmail.com"

# Install lsd
curl https://github.com/Peltoche/lsd/releases/download/0.16.0/lsd_0.16.0_amd64.deb -o ~/Downloads/lsd.deb
sudo dpkg -i ~/Downloads/lsd.deb
