#!/bin/bash
# Aaron's Scripts Installer

# Smylink *.py and *.sh to ~/bin, and make them all executable

echo "Installing scripts..."

SCRIPTS_DIRECTORY=$(cd $(dirname $0) && pwd)
for full_path_to_script in "$SCRIPTS_DIRECTORY"/{*.sh,*.py}
do
    filename=$(basename $full_path_to_script)
    if [[ "$filename" == "INSTALL.sh" || "$full_path_to_script" == *"/setup/"* ]]; then
        echo "Skipping install of $filename";
    else
        chmod +x $full_path_to_script
        filename=$(basename $full_path_to_script)
        ln -s "$full_path_to_script" ~/bin/"${filename%.*}"
        echo "SYMLINK: $full_path_to_script -> ~/bin/${filename%.*}"
    fi
done

echo "Installation complete!"
