#!/bin/bash
# Aaron's Scripts Installer

# Smylink *.py and *.sh to ~/.local/bin, and make them all executable

echo "Installing scripts to ~/.local/bin ..."

SCRIPTS_DIRECTORY=$(cd $(dirname $0) && pwd)
for full_path_to_script in "$SCRIPTS_DIRECTORY"/{*.sh,*.py}
do
    filename=$(basename $full_path_to_script)
    if [[ "$filename" == "INSTALL.sh" || "$full_path_to_script" == *"/setup/"* ]]; then
        echo "Skipping install of $filename";
    else
        chmod +x $full_path_to_script
        filename=$(basename $full_path_to_script)
        dest="$HOME/.local/bin/${filename%.*}"
        ln -s -v "$full_path_to_script" "$dest"
    fi
done

echo "Installation complete!"
