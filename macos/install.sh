if ! hash brew 2>/dev/null; then
 echo "Need to install homebrew first: https://brew.sh"
 exit
else
  echo "Homebrew is installed ✅"
fi

brew install ag curl nodejs diff-so-fancy ispell protobuf bat \
     tcpflow htop the_silver_searcher tmux tldr tree jq docker fzf \
     overmind reattach-to-user-namespace kubernetes-cli


brew tap heroku/brew
brew install heroku

brew cask install dropbox iterm2 1password dash firefox alfred bartender \
     spectacle tripmode slack emacs bitbar ngrok

# To install useful key bindings and fuzzy completion:
$(brew --prefix)/opt/fzf/install


mkdir -p ~/Library/KeyBindings
cp ./DefaultKeyBinding.dict ~/Library/KeyBindings/
./set-defaults.sh
