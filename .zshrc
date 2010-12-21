# mashiro .zshrc

# Default {{{1
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_to_home
setopt pushd_silent
setopt auto_param_slash
setopt auto_param_keys
setopt auto_list
setopt auto_menu
setopt auto_resume
setopt auto_name_dirs
setopt correct
setopt complete_in_word
setopt extended_glob
setopt list_packed
setopt list_types
setopt noautoremoveslash
setopt nolistbeep
setopt nocheckjobs
setopt no_beep
setopt always_last_prompt
setopt cdable_vars
setopt sh_word_split

autoload zmv
alias zmv='noglob zmv'


# Terminal {{{1
autoload -U colors; colors
case ${UID} in
0)
	PROMPT="%{${fg[cyan]}%}%n@%m%{${reset_color}%} %{${fg[red]}%}%/%%%{${reset_color}%}%b "
	PROMPT2="%{${fg[red]}%}%_%%%{${reset_color}%}%b "
	SPROMPT="%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
	;;
*)
	PROMPT="%{${fg[cyan]}%}%n@%m%{${reset_color}%} %{${fg_bold[red]}%}%/%%%{${reset_color}%} "
	PROMPT2="%{${fg_bold[red]}%}%_%%%{${reset_color}%} "
	SPROMPT="%{${fg_bold[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%} "
	;;
esac

export LSCOLORS=ExFxCxdxBxegedabagacad
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

case "${TERM}" in
kterm*|xterm*|screen*)
	precmd() {
		echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
        if [ -n "${SCREEN}" ]; then
            echo -ne "\ek$(basename $(pwd))/\e\\"
        fi
	}
    preexec() {
        if [ -n "${SCREEN}" ]; then
            echo -ne "\ek${1%%.*}\e\\"
        fi
    }
    ;;
esac


# Completion {{{1
autoload -U compinit; compinit
zstyle ':completion:*:default' menu select=1


# Keybind {{{1
bindkey -e
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end
bindkey "^[b" emacs-backward-ward
bindkey "^[f" emacs-forward-ward


# History {{{1
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt extended_history
setopt append_history
setopt inc_append_history
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_no_store
setopt hist_expand


# Alias {{{1
setopt complete_aliases     # aliased ls needs if file/dir completions work

case "${OSTYPE}" in
darwin*)
	alias ls="ls -G"
	;;
freebsd*|linux*)
	alias ls="ls --color=auto"
	;;
cygwin*)
	alias ls="ls --color=auto --show-control-chars"
	;;
esac

alias l="ls -al"
alias la="ls -a"
alias ll="ls -l"
alias lr="ls -alrt"

alias -g L="| less"
alias -g H="| head"
alias -g T="| tail"
alias -g G="| grep"
alias -g XG="| xargs grep"
alias -g V="| vim -R -"

alias view="vim -R -N --noplugin"

alias s="screen"
alias sr="screen -D -R"
alias srr="screen -D -RR"
alias sls="screen -ls"

alias cpan-uninstall='perl -MConfig -MExtUtils::Install -e '"'"'($FULLEXT=shift)=~s{-}{/}g;uninstall "$Config{sitear    chexp}/auto/$FULLEXT/.packlist",1'"'"
alias cpan-update="perl -MCPAN -e 'CPAN::Shell->install(CPAN::Shell->r)'"

alias where="command -v"
alias j="jobs -l"
alias du="du -h"
alias df="df -h"
alias su="su -l"
alias sudo="sudo "
alias :q="exit"

alias py="python"

case "${OSTYPE}" in
darwin*)
	alias port-update="sudo port selfupdate; sudo port outdated"
	alias port-upgrade="sudo port upgrade --enforce-variants installed"
	;;
freebsd*)
	case ${UID} in
	0)
		updateports() 
		{
			if [ -f /usr/ports/.portsnap.INDEX ]; then
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


# End {{{1
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

