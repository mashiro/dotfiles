# users generic .zshrc file for zsh(1)


## Default shell configuration
autoload colors
colors
case ${UID} in
0)
    PROMPT="%B%{${fg[red]}%}%/#%{${reset_color}%}%b "
    PROMPT2="%B%{${fg[red]}%}%_#%{${reset_color}%}%b "
    SPROMPT="%B%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
        PROMPT="%{${fg[cyan]}%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') ${PROMPT}"
    ;;
*)
    PROMPT="%{${fg_bold[red]}%}%/%%%{${reset_color}%} "
    PROMPT2="%{${fg_bold[red]}%}%_%%%{${reset_color}%} "
    SPROMPT="%{${fg_bold[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%} "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
        PROMPT="%{${fg[cyan]}%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') ${PROMPT}"
    ;;
esac

setopt auto_cd
setopt auto_pushd
setopt correct
setopt list_packed
setopt noautoremoveslash
setopt nolistbeep
setopt nocheckjobs


## Keybind configuration
bindkey -e
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end


## Command history configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt share_history            # share command history data
setopt hist_ignore_all_dups
setopt hist_ignore_dups         # ignore duplication command history list
setopt hist_save_no_dups


## Completion configuration
fpath=(~/.zsh/functions/Completion ${fpath})
autoload -U compinit
compinit


## zsh editor
autoload zed


## Prediction configuration
autoload predict-on


## Alias configuration
setopt complete_aliases     # aliased ls needs if file/dir completions work

alias where="command -v"
alias j="jobs -l"

case "${OSTYPE}" in
darwin*)
    alias ls="ls -G -w"
    ;;
freebsd*|linux*)
    alias ls="ls --color"
    ;;
esac

alias la="ls -a"
alias lf="ls -F"
alias ll="ls -l"

alias du="du -h"
alias df="df -h"

alias su="su -l"

# screen
alias s='screen -U'
alias sr='screen -U -D -R'
alias srr='screen -U -D -RR'

# cpan
alias cpan-uninstall='perl -MConfig -MExtUtils::Install -e '"'"'($FULLEXT=shift)=~s{-}{/}g;uninstall "$Config{sitear    chexp}/auto/$FULLEXT/.packlist",1'"'"
alias cpan-update="perl -MCPAN -e 'CPAN::Shell->install(CPAN::Shell->r)'"

# sudo
alias sudo="sudo "

# exit
alias :q=exit


case "${OSTYPE}" in
darwin*)
    alias portupdate="sudo port selfupdate; sudo port outdated"
    alias portupgrade="sudo port upgrade --enforce-variants installed"
    ;;
freebsd*)
    case ${UID} in
    0)
        updateports() 
        {
            if [ -f /usr/ports/.portsnap.INDEX ]
            then
                portsnap fetch update
            else
                portsnap fetch extract update
            fi
            (cd /usr/ports/; make index)

            portversion -v -l \<
        }
        alias appsupgrade='pkgdb -F && BATCH=YES NO_CHECKSUM=YES portupgrade -a'
        ;;
    esac
    ;;
esac


## terminal configuration
export LSCOLORS=ExFxCxdxBxegedabagacad
export LS_COLORS='di=01;35:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors 'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'


# set terminal title including current directory
case "${TERM}" in
kterm*|xterm*)
    precmd() {
        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
    }
    ;;
esac


## load user .zshrc configuration file
[ -f ~/.zshrc.mine ] && source ~/.zshrc.mine

