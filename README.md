# Scripts

Some scripts I've written, modified, or borrowed.

Any licenses that came with the scripts have been preserved. Credit is given in scripts that are not my own.

## Installation

To install all scripts to `~/bin/$SCRIPT`:

```bash
# Clone the repo and enter the directory
$ git clone https://github.com/alichtman/scripts.git && cd scripts
$ chmod +x INSTALL.sh && ./INSTALL.sh
```

Scripts are installed without extensions, so `scripts/tls.sh` gets symlinked to `~/bin/tls`.

Remember to add `~/bin` to your `$PATH`, or change the install location before running the install script.
