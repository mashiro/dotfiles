# mashiro .zshrc

# Default shell {{{1
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


# Keybind {{{1
bindkey -e
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end


# Command history {{{1
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt share_history            # share command history data
setopt hist_ignore_all_dups
setopt hist_ignore_dups         # ignore duplication command history list
setopt hist_save_no_dups


# Completion {{{1
fpath=(~/.zsh/functions/Completion ${fpath})
autoload -U compinit
compinit


# Alias {{{1
setopt complete_aliases     # aliased ls needs if file/dir completions work

# ls {{{2
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

# screen {{{2
alias s='screen -U'
alias sr='screen -U -D -R'
alias srr='screen -U -D -RR'

# cpan {{{2
alias cpan-uninstall='perl -MConfig -MExtUtils::Install -e '"'"'($FULLEXT=shift)=~s{-}{/}g;uninstall "$Config{sitear    chexp}/auto/$FULLEXT/.packlist",1'"'"
alias cpan-update="perl -MCPAN -e 'CPAN::Shell->install(CPAN::Shell->r)'"

# others {{{2
alias where="command -v"
alias j="jobs -l"
alias du="du -h"
alias df="df -h"
alias su="su -l"
alias sudo="sudo "
alias :q=exit


# ostype {{{2
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


# Terminal {{{1
export LSCOLORS=ExFxCxdxBxegedabagacad
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors 'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'

case "${TERM}" in
kterm*|xterm*)
    precmd() {
        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
    }
    ;;
esac


# Export {{{1
export LESS="-R"


# End {{{1
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

