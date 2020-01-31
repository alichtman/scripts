# Scripts

Some scripts I've written, modified, or borrowed.

Any licenses that came with the scripts have been preserved. Credit is given in scripts that are not my own.

## Installation

To install these, just move (or symlink) them to a directory that's on your `$PATH` (like `/usr/local/bin/` or `~/bin`) after making them executable.

```bash
$ git clone https://github.com/alichtman/scripts.git && cd scripts
$ chmod +x $SCRIPT_NAME
# Move them to a directory on $PATH
$ mv $SCRIPT_NAME /usr/local/bin/
# Or symlink them there
$ ln -s $(realpath $SCRIPT_NAME) /usr/local/bin/
```
