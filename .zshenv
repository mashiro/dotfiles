# Utility {{{1
register_paths() { # {{{2
    dir="$1"
    if [ -d "$dir" ] || [ -z "$dir" ]; then
        if [ -d "$dir/bin" ]; then PATH="$dir/bin:$PATH"; fi
        if [ -d "$dir/sbin" ]; then PATH="$dir/sbin:$PATH"; fi
        if [ -d "$dir/man" ]; then MANPATH="$dir/man:$MANPATH"; fi
        if [ -d "$dir/share/man" ]; then MANPATH="$dir/share/man:$MANPATH"; fi
        if [ -d "$dir/info" ]; then INFOPATH="$dir/info:$INFOPATH"; fi
        if [ -d "$dir/include" ]; then INCLUDE_PATH="$dir/include:$INCLUDE_PATH"; fi
        if [ -d "$dir/lib" ]; then LIBRARY_PATH="$dir/lib:$LIBRARY_PATH"; fi
        for i in $dir/*; do
            if [ -d "$i/bin" ]; then PATH="$i/bin:$PATH"; fi
            if [ -d "$i/sbin" ]; then PATH="$i/sbin:$PATH"; fi
            if [ -d "$i/man" ]; then MANPATH="$i/man:$MANPATH"; fi
            if [ -d "$i/share/man" ]; then MANPATH="$i/share/man:$MANPATH"; fi
            if [ -d "$i/info" ]; then INFOPATH="$i/info:$INFOPATH"; fi
            if [ -d "$i/include" ]; then INCLUDE_PATH="$i/include:$INCLUDE_PATH"; fi
            if [ -d "$i/lib" ]; then LIBRARY_PATH="$i/lib:$LIBRARY_PATH"; fi
        done
    fi
}

source_if() { # {{{2
    [[ -s "$1" ]] && source "$1"
}

# Manager {{{1
before_register_paths() {
    # perlbrew
    source_if "$HOME/perl5/perlbrew/etc/bashrc"
}

after_register_paths() {
    # homebrew (OSX)
    [[ -d "/usr/local/share/python" ]] && export PATH=/usr/local/share/python:$PATH

    # pythonbrew
    source_if "$HOME/.pythonbrew/etc/bashrc"

    # virtualenv
    export PYTHONSTARTUP=$HOME/.pythonstartup
    export WORKON_HOME=$HOME/.virtualenvs
    if [ -d $WORKON_HOME ]; then
        export VIRTUALENVERAPPER_SH=`which virtualenvwrapper.sh`
        source_if "$VIRTUALENVERAPPER_SH"
    fi

    # rvm
    source_if "$HOME/.rvm/scripts/rvm"

    # rbenv
    if [ -d "$HOME/.rbenv" ]; then
        export PATH=$HOME/.rbenv/bin:$PATH
        eval "$(rbenv init -)"
    fi

    # nvm
    source_if "$HOME/.nvm/nvm.sh"

    # nodebrew
    [[ -d "$HOME/.nodebrew" ]] && export PATH=$HOME/.nodebrew/current/bin:$PATH

    # cabal
    [[ -d "$HOME/.cabal" ]] && export PATH=$HOME/.cabal/bin:$PATH
}

# Export {{{1
# Path {{{2
#if [ -n "$SCREEN" -o -z "$REGISTER_PATHS_COMPLETED" ]; then
if [ -z "$REGISTER_PATHS_COMPLETED" ]; then
    before_register_paths

    # for Defaults
    register_paths ""
    register_paths "/usr"
    
    # for MacPorts
    register_paths "/opt/local"

    # for manually build applications
    register_paths "/usr/local"

    # for my own tools
    register_paths "$HOME/local"
    register_paths "$HOME/local/enabled"

    # export
    # export PATH MANPATH INFOPATH
    # export INCLUDE_PATH
    # export C_INCLUDE_PATH=$INCLUDE_PATH
    # export CPP_INCLUDE_PATH=$INCLUDE_PATH
    # export LIBRARY_PATH
    # export LD_LIBRARY_PATH=$LIBRARY_PATH

    # completed
    export REGISTER_PATHS_COMPLETED=1

    after_register_paths

    export _PATH=$PATH
else
    [ -n $_PATH ] && export PATH=$_PATH
fi

# Misc {{{2
export TZ=JST-9
export EDITOR=`which vim`
export PAGER=`which less`
export SHELL=`which zsh`
export LESS="-i -M -R"
export GREP_COLOR="01;33"
export GREP_OPTIONS="--color=auto"
export WORDCHARS="*?_-.[]~=&;!#$%^(){}<>"

# SSH-Agent {{{2
SSH_AGENT=`which ssh-agent`
SSH_ADD=`which ssh-add`
SSH_ENV="$HOME/.ssh/environment"

function start_ssh_agent {
    echo "Initialising new SSH agent..."
    $SSH_AGENT | head -n 2 > $SSH_ENV
    chmod 600 $SSH_ENV
    . $SSH_ENV > /dev/null
    $SSH_ADD < /dev/null
}

if [ -f $SSH_ENV ]; then
    . $SSH_ENV > /dev/null
    ps -ef | grep $SSH_AGENT_PID | grep ssh-agent$ > /dev/null || {
        start_ssh_agent
    }   
else
    start_ssh_agent
fi

# End {{{1
source_if "$HOME/.zshenv.local"

