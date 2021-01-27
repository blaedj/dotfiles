# TODO: need to install sway, swayidle, sway-lock
# see https://github.com/swaysm for these.
# also probably waybar: https://github.com/Alexays/Waybar


mkdir -p ~/.config/sway
mkdir -p ~/.config/waybar
mkdir -p ~/.swaylock
ln -sf ~/.dotfiles/sway/config ~/.config/sway/config
ln -sf ~/.dotfiles/sway/waybar.json ~/.config/waybar/config
ln -sf ~/.dotfiles/sway/swaylock.config ~/.swaylock/config
