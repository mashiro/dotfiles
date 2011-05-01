# Export {{{1
# Path {{{2
export PATH MANPATH INFOPATH
register_paths() {
    dir="$1"
    if [ -d "$dir" ]; then
        if [ -d "$dir/bin" ]; then PATH="$dir/bin:$PATH"; fi
        if [ -d "$dir/sbin" ]; then PATH="$dir/sbin:$PATH"; fi
        if [ -d "$dir/man" ]; then MANPATH="$dir/man:$MANPATH"; fi
        if [ -d "$dir/share/man" ]; then MANPATH="$dir/share/man:$MANPATH"; fi
        if [ -d "$dir/info" ]; then INFOPATH="$dir/info:$INFOPATH"; fi
        for i in $dir/*; do
            if [ -d "$i/bin" ]; then PATH="$i/bin:$PATH"; fi
            if [ -d "$i/sbin" ]; then PATH="$i/sbin:$PATH"; fi
            if [ -d "$i/man" ]; then MANPATH="$i/man:$MANPATH"; fi
            if [ -d "$i/share/man" ]; then MANPATH="$i/share/man:$MANPATH"; fi
            if [ -d "$i/info" ]; then INFOPATH="$i/info:$INFOPATH"; fi
        done
    fi
}

case "${OSTYPE}" in
darwin*)
    export PATH="/usr/bin:/bin:/usr/sbin:/sbin"
    export REGISTER_PATHS_COMPLETED=""
	;;
esac

if ! [ "$REGISTER_PATHS_COMPLETED" ]; then
    # for MacPorts
    register_paths "/opt/local"

    # for manually build applications
    register_paths "/usr/local"

    # for my own tools
    register_paths "$HOME/local"

    # completed
    export REGISTER_PATHS_COMPLETED=1
fi


# Misc {{{2
export TZ=JST-9
export EDITOR=$(which vim)
export PAGER=$(which less)
export SHELL=$(which zsh)
export LESS="-i -M -R"
export GREP_COLOR="01;33"
export GREP_OPTIONS="--color=auto"
export WORDCHARS="*?_-.[]~=&;!#$%^(){}<>"


# Python {{{2
[[ -d "/usr/local/share/python" ]] && export PATH=/usr/local/share/python:$PATH
export PYTHONSTARTUP=$HOME/.pythonstartup
export WORKON_HOME=$HOME/.virtualenvs
if [ -d $WORKON_HOME ]; then
    export VIRTUALENVERAPPER_SH=$(which virtualenvwrapper.sh)
    [[ -s "$VIRTUALENVERAPPER_SH" ]] && . "$VIRTUALENVERAPPER_SH"
fi


# Ruby {{{2
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.


# End {{{1
[ -f ~/.zshenv.local ] && source ~/.zshenv.local
