#!/bin/bash
# This script does basic linux setup

# zsh
sudo apt install zsh
chsh -s $(which zsh)

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

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
source ~/.zshrc


sudo apt-get install ctags
sudo apt install hub xsel

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


curl https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy -o ~/bin/diff-so-fancy
chmod +x ~/bin/diff-so-fancy
