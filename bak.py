#!/usr/bin/env python3

# This is a local backup tool. Handles files and directories while preserving the metadata.

import os
from sys import argv
from glob import glob
import shutil
import argparse

def main():
	parser = argparse.ArgumentParser(description='Creates local backup files, ending in .bak')
	parser.add_argument('files', metavar='file', type=str, nargs='+', help='files to be backed up. Accepts globs')
	args = parser.parse_args()

	globbed_list_of_files = []
	for file in argv[1:]:
		globbed = glob(file)
		if globbed != []:
			globbed_list_of_files.extend(globbed)

	for file in globbed_list_of_files:
		if file.endswith("/"):
			directory = file
			file = file[:-1]
		bak_path = f"{file}.bak"
		if os.path.isfile(file):
			print(f"{file} -> {bak_path}")
			shutil.copy2(file, bak_path)

		else: # is directory
			print(f"{file} -> {bak_path}/")
			shutil.copytree(file, bak_path)



if __name__ == "__main__":
	main()
