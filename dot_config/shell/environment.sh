# Import ~/.config/environment.d. POSIX sh: sourced by ~/.zshenv, ~/.profile
# and ~/.xsessionrc.
#
# The systemd user manager reads environment.d itself, and the X session
# imports it in ~/.xsessionrc, so terminals started from i3 already have it.
# Shells started any other way (tty login, ssh, `ssh host cmd`) don't inherit
# it, so import it here. ENVIRONMENT_D_IMPORTED (set by 99-imported.conf)
# prevents a second import, which would prepend PATH entries again.
if [ -z "${ENVIRONMENT_D_IMPORTED:-}" ] \
	&& [ -x /usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator ]; then
	eval "$(/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator | sed 's/^/export /')"
fi
