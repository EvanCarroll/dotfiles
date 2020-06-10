emulate sh
	. ~/.profile
emulate zsh

. ~/.config/environment.d/00-path.conf

systemctl --wait --user import-environment

# If running from tty1 start sway
if [ "$(tty)" = "/dev/tty1" ]; then
	exec systemctl --wait --user start sway.service
fi
