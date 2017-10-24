if ! hash brew 2>/dev/null; then
 echo "Need to install homebrew first: https://brew.sh"
 exit
else
  echo "Homebrew is installed ✅"
fi

brew install ag curl nodejs diff-so-fancy ispell

brew cask install dropbox iterm2 1password dash firefox alfred bartender
brew cask install spectacle tripmode flux slack emacs bitbar ngrok

cp ./DefaultKeyBinding.dict ~/Library/KeyBindings/
./set_defaults.sh
