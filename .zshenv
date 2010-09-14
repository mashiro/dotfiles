# Export {{{1
# Path {{{2
export PATH MANPATH INFOPATH
function find_paths {
	dir="$1"
	if [ -d "$dir" ]; then
		if [ -d "$dir/bin" ]; then PATH="$dir/bin:$PATH"; fi
		if [ -d "$dir/sbin" ]; then PATH="$dir/sbin:$PATH"; fi
		if [ -d "$dir/man" ]; then MANPATH="$dir/man:$MANPATH"; fi
		if [ -d "$dir/share/man" ]; then MANPATH="$dir/share/man:$MANPATH"; fi
		if [ -d "$dir/info" ]; then INFOPATH="$dir/info:$INFOPATH"; fi
		for i in "$dir/*"; do
			if [ -d "$i/bin" ]; then PATH="$i/bin:$PATH"; fi
			if [ -d "$i/sbin" ]; then PATH="$i/sbin:$PATH"; fi
			if [ -d "$i/man" ]; then MANPATH="$i/man:$MANPATH"; fi
			if [ -d "$i/share/man" ]; then MANPATH="$i/share/man:$MANPATH"; fi
			if [ -d "$i/info" ]; then INFOPATH="$i/info:$INFOPATH"; fi
		done
	fi
}

if ! [ "$PATH_FIND_COMPLETED" ]; then
	# for MacPorts
	find_paths "/opt/local"

	# for manually build applications
	find_paths "/usr/local"

	# for my own tools
	find_paths "$HOME/local"

	# completed
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

