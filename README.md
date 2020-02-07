# Scripts

Some scripts I've written, modified, or borrowed.

Any licenses that came with the scripts have been preserved. Credit is given in scripts that are not my own.

## Installation

For all bash scripts, installation can be done with:

```bash
# Clone the repo and enter the directory
$ git clone https://github.com/alichtman/scripts.git && cd scripts
# Make the script you want to install executable
$ chmod +x $SCRIPT_NAME
# Move it to a directory on $PATH
$ mv $SCRIPT_NAME /usr/local/bin/
# Or symlink it there
$ ln -s $(realpath $SCRIPT_NAME) /usr/local/bin/
```

Some scripts may need to be compiled before being symlinked, however. This has been noted in the scripts where it's necessary.
