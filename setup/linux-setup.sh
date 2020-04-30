#!/bin/bash
# This script does (highly opinionated) Linux setup on Debian-based distros.
# Some of the git repos cloned below are private to @alichtman and will require access.
# Written by: Aaron Lichtman (@alichtman on GitHub)

echo "Have you added contrib and non-free to the /etc/apt/sources.list file?"
echo "    -> https://wiki.debian.org/SourcesList"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) echo "Continuing."; break;;
        No ) exit;;
    esac
done

sudo apt update

# zsh
sudo apt install zsh
chsh -s "$(command -v zsh)"

# oh-my-zsh
[ -d ~/.oh-my-zsh ] || sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

pip3 install shallow-backup>=4.0.1
pip3 install pynvim thefuck

# shallow-backup + dotfiles
# TODO: Convert to dotbot?
mkdir ~/shallow-backup
git clone https://github.com/alichtman/dotfiles ~/shallow-backup/dotfiles
mv ~/shallow-backup/dotfiles/.config/shallow-backup.conf ~/.config
shallow-backup -reinstall_dots

# vim-plug for neovim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install nvim and plugins
sudo apt install neovim
nvim '+PlugUpdate' '+PlugUpgrade' '+CocUpdate' '+qall'

# zinit
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"

# shellcheck disable=SC1090
source "$XDG_CONFIG_HOME/zsh/.zshrc"

# install yq
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CC86BB64
sudo add-apt-repository ppa:rmescandon/yq
sudo apt install yq -y

sudo apt install ctags ranger fzf silversearcher-ag libclang-dev hub xsel ddgr htop git-extras latte-dock polybar tmux -y

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

# Install lsd
curl https://github.com/Peltoche/lsd/releases/download/0.16.0/lsd_0.16.0_amd64.deb -o ~/Downloads/lsd.deb
sudo dpkg -i ~/Downloads/lsd.deb
rm ~/Downloads/lsd.deb

# tmux setup
ln -s ~/.tmux/tmux.conf ~/.tmux.conf
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Install tpm packages
~/.tmux/plugins/tpm/bin/install_plugins

# Install diff-so-fancy
curl https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy -o ~/bin/diff-so-fancy
chmod +x ~/bin/diff-so-fancy

# Clone my repos
# TODO: Move ~/Desktop/Development to ~/Development ?
mkdir ~/Desktop/Development
git clone --recursive git@github.com:alichtman/notes.git ~/Desktop/Development/notes
git clone git@github.com:alichtman/writeups.git ~/Desktop/Development/writeups
git clone git@github.com:alichtman/scripts.git ~/Desktop/Development/scripts
git clone git@github.com:alichtman/fzf-notes.git ~/Desktop/Development/fzf-notes

# Install my scripts
mkdir ~/bin
(cd ~/Desktop/Development/fzf-notes && chmod +x fzf-notes && ln -s "$(realpath fzf-notes)" ~/bin/fzf-notes)
(cd ~/Desktop/Development/scripts && chmod +x tls.sh && ln -s "$(realpath tls.sh)" ~/bin/tls)

# Install fonts with glyph support
# TODO: Actually install things
git clone git@github.com:alichtman/patched-nerd-fonts.git ~/Desktop/Development/patched-nerd-fonts

# Install cargo
curl https://sh.rustup.rs -sSf | sh

cargo install ripgrep bat fd-find

curl https://raw.githubusercontent.com/denilsonsa/prettyping/master/prettyping -o ~/bin/prettyping && chmod +x ~/bin/prettyping

echo -e "## Setup Complete"
echo -e "## Rememer to install the fonts you want to use!"
