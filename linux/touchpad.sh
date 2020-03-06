#!/usr/bin/env bash

# This script sets up some tools to enable advanced gesture recognition in Gnome

# need to add user to the input group
sudo gpasswd -a $USER input
echo "Must restart for group assignment to take effect"

sudo apt install libinput-tools

gem install fusuma

# optional, for sending shortcuts via gestures
sudo apt install xdotool

mkdir -p ~/.config/fusuma
ln -s ~/.dotfiles/linux/gestures.yml ~/.config/fusuma/config.yml
