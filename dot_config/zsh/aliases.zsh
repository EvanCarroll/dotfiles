# Interactive aliases, sourced from ~/.zshrc after oh-my-zsh so these win.

alias ls='lsd'
alias l='lsd -l'
alias la='lsd -la'

# oh-my-zsh's git plugin owns `g`
alias gw='gcc -std=gnu11 -Wall -Wextra -Wpedantic -Wstrict-overflow -fno-strict-aliasing'

alias mssql-cli='mssql-cli -U sa -P "$MSSQL_SA_PASSWORD"'
alias sqlcmd='sqlcmd -H localhost -U sa -P "$MSSQL_SA_PASSWORD" -I'
alias rsync='rsync -avr --progress --inplace'
alias seedup='rsync --ignore-existing *.torrent rg-seedbox:torrents/'
alias vlcmusic='vlc --sout="#duplicate{dst=display{delay=2800},dst=chromecast{ip=10.0.0.135,audio=1}}"'
alias tmux='TERM=xterm-256color tmux -2'
alias lan='cd ~/vpn/home/client/'

if [[ $TERM == xterm-kitty || -n $KITTY_WINDOW_ID ]]; then
	alias ssh='kitty +kitten ssh'
fi
