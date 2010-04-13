# Export {{{1
# Path {{{2
export PATH MANPATH INFOPATH
if ! [ "$PATH_FIND_COMPLETED" ]; then
	# for MacPorts
	if [ -d /opt/local ]; then
		for i in /opt/local/{bin,sbin}; do
			if [ -d "$i" ]; then
				#PATH="$i:$PATH"
			fi
		done
		if [ -d "/opt/local/share/man" ]; then
			MANPATH="/opt/local/share/man:$MANPATH"
		fi
	fi

	# for manually build applications
	if [ -d /usr/local ]; then
		for i in /usr/local/*; do
			if [ -d "$i/bin" ]; then PATH="$i/bin:$PATH"; fi
			if [ -d "$i/man" ]; then MANPATH="$i/man:$MANPATH"; fi
			if [ -d "$i/share/man" ]; then MANPATH="$i/share/man:$MANPATH"; fi
			if [ -d "$i/info" ]; then INFOPATH="$i/info:$INFOPATH"; fi
		done
	fi

	# for my own tools
	if [ -d "$HOME/bin" ]; then PATH="$HOME/bin:$PATH"; fi
	if [ -d "$HOME/man" ]; then MANPATH="$HOME/man:$MANPATH"; fi
	if [ -d "$HOME/share/man" ]; then MANPATH="$HOME/share/man:$MANPATH"; fi
	if [ -d "$HOME/info" ]; then INFOPATH="$HOME/info:$INFOPATH"; fi

	export PATH_FIND_COMPLETED=1
fi


# Misc {{{2
export EDITOR=vim
export PAGER=less
export SHELL=$(which zsh)
export LESS="-i -M -R"
export TZ=JST-9


# End {{{1
[ -f ~/.zshenv.local ] && source ~/.zshenv.local
