#!/bin/env python3

from glob import glob
from pathlib import Path

import click

CONTEXT_SETTINGS = dict(help_option_names=["-h", "--help"])


@click.command(context_settings=CONTEXT_SETTINGS)
@click.argument("files", nargs=-1, type=click.Path(exists=True))
@click.option(
    "-u",
    "--undo",
    default=False,
    is_flag=True,
    help="Replace the .bak files with the original files, overwriting any files with the same name",
)
@click.option(
    "-d",
    "--dryrun",
    default=False,
    is_flag=True,
    help="Show what would be done without actually doing it",
)
def main(undo, files, dryrun):
    """Local backup tool. Backup files or directories by creating a .bak file."""
    bak_suffix = ".bak"
    globbed_list_of_files = []
    for file in files:
        globbed = glob(file)
        print(globbed)

        # if we're undoing, drop everything that ends in bak
        if undo:
            globbed = [f for f in globbed if f.endswith(bak_suffix)]

        if globbed:
            globbed_list_of_files.extend(globbed)

    for file in globbed_list_of_files:
        file = Path(file).resolve()
        if not file.exists():
            print(f"Error: {file} does not exist")
            continue

        # Normal backup, move everything to .bak
        if not undo:
            bak_path = f"{file}{bak_suffix}"
            print(f"{file} -> {bak_path}")
            if not dryrun:
                file.rename(bak_path)
        else:
            # Undo backup, move everything back to original (deleting the .bak suffix, overwriting any files by the same name). This list is already filtered to only include .bak files
            original_path = str(file)[:-4]
            print(f"{file} -> {original_path}")
            if not dryrun:
                file.rename(original_path)


if __name__ == "__main__":
    main()
