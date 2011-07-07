# mashiro .zshrc

# Default {{{1
setopt always_last_prompt
setopt pushd_ignore_dups
setopt pushd_to_home
setopt pushd_silent
setopt auto_cd
setopt auto_pushd
setopt auto_param_slash
setopt auto_param_keys
setopt auto_list
setopt auto_menu
setopt auto_resume
setopt no_auto_name_dirs
setopt correct
setopt complete_in_word
setopt brace_ccl
setopt no_cdable_vars
setopt no_extended_glob
setopt list_packed
setopt list_types
setopt no_auto_remove_slash
setopt no_list_beep
setopt no_check_jobs
setopt no_flow_control
setopt no_beep
setopt no_hup
setopt notify
setopt sh_word_split
setopt magic_equal_subst
setopt prompt_subst
setopt print_eight_bit

autoload zmv
alias zmv='noglob zmv'


# Terminal {{{1
autoload -Uz colors; colors
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


case "${TERM}" in
kterm*|xterm*|screen*)
	precmd() {
        echo -ne "\e]2;${USER}@${HOST%%.*}:${PWD}\a"
        if [ -n "${SCREEN}" ]; then
            echo -ne "\ek${PWD:t}/\e\\"
        fi
	}
    preexec() {
        if [ -n "${SCREEN}" ]; then
            echo -ne "\ek${1%% *}\e\\"
        fi
    }
    ;;
esac


autoload -Uz add-zsh-hook
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git svn hg bzr
zstyle ':vcs_info:*' formats '%s@%b'
zstyle ':vcs_info:*' actionformats '%s@%b|%a'
zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:r%r'
zstyle ':vcs_info:bzr:*' use-simple true

autoload -Uz is-at-least
if is-at-least 4.3.10; then
  zstyle ':vcs_info:git:*' check-for-changes true
  zstyle ':vcs_info:git:*' stagedstr "+"
  zstyle ':vcs_info:git:*' unstagedstr "-"
  zstyle ':vcs_info:git:*' formats '%s@%b %c%u'
  zstyle ':vcs_info:git:*' actionformats '%s@%b|%a %c%u'
fi

function _update_vcs_info_msg() {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
add-zsh-hook precmd _update_vcs_info_msg
RPROMPT="%1(v|%F%{${fg[cyan]}%}%1v%f|)"


# Completion {{{1
autoload -Uz compinit; compinit
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}


# Keybind {{{1
bindkey -e
autoload -Uz history-search-end
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
	alias ls="ls -F -G"
	;;
freebsd*|linux*)
	alias ls="ls -F --color=auto"
	;;
cygwin*)
	alias ls="ls -F --color=auto --show-control-chars"
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
alias pyb="pythonbrew"

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

