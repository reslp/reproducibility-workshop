#!/usr/bin/env bash
# This script helps to set up a new project directory structure.
# usage: ./create-project.sh <projectname>

set -e #exit as soon as an error occurs

echo "Will setup a project called: "$1
mkdir $1
echo "Will create subdirectories for project: bin doc data results tmp"
cd $1
mkdir bin doc data results tmp
read -p "Would you like to initialize a git repository? (y/n)" initgit
if [[ $initgit == "y" || $initgit == "Y" ]]; then
	git init
elif [[ $initgit == "n" || $initgit == "N" ]]; then
	echo "OK, will not initialize a git repository"
else
	echo "Wrong input. Please specify y or n."
	cd ..
	rm -rf $1
	exit
fi

read -p "Would you like to permanently add the project's bin directory to the PATH (this assumes bash and ~/.bashrc is used)? (y/n)" askpath
if [[ $initgit == "y" || $initgit == "Y" ]]; then
	echo "export PATH=\"\$PATH:$(pwd)/bin\"" >> $HOME/.bashrc
	echo "PATH has been changed you need to run: source ~/.bashrc to activate the changes"
elif [[ $initgit == "n" || $initgit == "N" ]]; then
	echo "OK, will not alter PATH."
else
	echo "Wrong input. Please specify y or n."
	cd ..
	rm -rf $1
	exit
fi





