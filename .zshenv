# Export {{{1
# Path {{{2
export PATH MANPATH INFOPATH
if ! [ "$PATH_FIND_COMPLETED" ]; then
	# for MacPorts
	dir="/opt/local"
	if [ -d "$dir" ]; then
		if [ -d "$dir/bin" ]; then PATH="$dir/bin:$PATH"; fi
		if [ -d "$dir/sbin" ]; then PATH="$dir/sbin:$PATH"; fi
		if [ -d "$dir/man" ]; then MANPATH="$dir/man:$MANPATH"; fi
		if [ -d "$dir/share/man" ]; then MANPATH="$dir/share/man:$MANPATH"; fi
		if [ -d "$dir/info" ]; then INFOPATH="$dir/info:$INFOPATH"; fi
	fi

	# for manually build applications
	dir="/usr/local"
	if [ -d "$dir" ]; then
		if [ -d "$dir/bin" ]; then PATH="$dir/bin:$PATH"; fi
		if [ -d "$dir/sbin" ]; then PATH="$dir/sbin:$PATH"; fi
		if [ -d "$dir/man" ]; then MANPATH="$dir/man:$MANPATH"; fi
		if [ -d "$dir/share/man" ]; then MANPATH="$dir/share/man:$MANPATH"; fi
		if [ -d "$dir/info" ]; then INFOPATH="$dir/info:$INFOPATH"; fi
		for i in /usr/local/*; do
			if [ -d "$i/bin" ]; then PATH="$i/bin:$PATH"; fi
			if [ -d "$i/sbin" ]; then PATH="$i/sbin:$PATH"; fi
			if [ -d "$i/man" ]; then MANPATH="$i/man:$MANPATH"; fi
			if [ -d "$i/share/man" ]; then MANPATH="$i/share/man:$MANPATH"; fi
			if [ -d "$i/info" ]; then INFOPATH="$i/info:$INFOPATH"; fi
		done
	fi

	# for my own tools
	dir="$HOME"
	if [ -d "$dir" ]; then
		if [ -d "$dir/bin" ]; then PATH="$dir/bin:$PATH"; fi
		if [ -d "$dir/sbin" ]; then PATH="$dir/sbin:$PATH"; fi
		if [ -d "$dir/man" ]; then MANPATH="$dir/man:$MANPATH"; fi
		if [ -d "$dir/share/man" ]; then MANPATH="$dir/share/man:$MANPATH"; fi
		if [ -d "$dir/info" ]; then INFOPATH="$dir/info:$INFOPATH"; fi
	fi

	# completed
	export PATH_FIND_COMPLETED=1
fi


# Misc {{{2
export EDITOR=$(which vim)
export PAGER=$(which less)
export SHELL=$(which zsh)
export LESS="-i -M -R"
export TZ=JST-9


# End {{{1
[ -f ~/.zshenv.local ] && source ~/.zshenv.local
