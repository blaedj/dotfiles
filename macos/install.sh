if ! hash brew 2>/dev/null; then
 echo "Need to install homebrew first: https://brew.sh"
 exit
else
  echo "Homebrew is installed ✅"
fi

brew install ag curl nodejs diff-so-fancy ispell protobuf bat \
     tcpflow htop the_silver_searcher tmux tldr tree jq

brew cask install dropbox iterm2 1password dash firefox alfred bartender \
     spectacle tripmode slack emacs bitbar ngrok

cp ./DefaultKeyBinding.dict ~/Library/KeyBindings/
./set_defaults.sh
