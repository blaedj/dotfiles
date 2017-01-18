#!/usr/bin/env bash

# list of npm modules to be globablly installed
# 

# install node
brew install node 

# make sure npm is up to date
npm install npm -g

# install favorite global npm modules
npm install -g caniuse-cmd coffee coffeelint
