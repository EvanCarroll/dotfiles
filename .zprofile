emulate sh
. ~/.profile
emulate zsh

systemctl --user import-environment

# If running from tty1 start sway
if [ "$(tty)" = "/dev/tty1" ]; then
	exec systemctl --wait --user start sway.service
fi
