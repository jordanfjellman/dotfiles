#!/bin/bash
############################
# make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=$HOME/dotfiles                            # dotfiles directory
backupDir=$HOME/dotfiles_backup                     # old dotfiles backup directory
files=".bashrc .vimrc .vim .zshrc .oh-my-zsh" # list of files/folders to symlink in homedir

##########

# create dotfiles_old in homedir
echo "Creating $backupDir for backup of any existing dotfiles in ~"
mkdir -p $backupDir
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
for file in $files; do
    echo "Moving any existing dotfiles from ~ to $backupDir"
    mv $HOME/$file $HOME/dotfiles_backup/
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file $HOME/$file
done