if ! hash brew 2>/dev/null; then
 echo "Need to install homebrew first: https://brew.sh"
 exit
else
  echo "Homebrew is installed ✅"
fi

brew install ag curl nodejs diff-so-fancy ispell protobuf bat \
     tcpflow htop the_silver_searcher tmux tldr tree jq docker fzf \
     overmind reattach-to-user-namespace git-delta

brew tap heroku/brew
brew install heroku

brew install dropbox homebrew/cask/iterm2 homebrew/cask/1password \
     homebrew/cask/dash firefox alfred bartender \
     spectacle tripmode slack ngrok licecap suspicious-package \
     watch wtfutil fd rectangle

brew install --cask 1password/tap/1password-cli

# To install useful key bindings and fuzzy completion:
$(brew --prefix)/opt/fzf/install


mkdir -p ~/Library/KeyBindings
cp ./DefaultKeyBinding.dict ~/Library/KeyBindings/
./set-defaults.sh
