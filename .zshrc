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
setopt no_correct
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
typeset -Ag FX FG BG

FX=(
    reset     "%{[00m%}"
    bold      "%{[01m%}" no-bold      "%{[22m%}"
    italic    "%{[03m%}" no-italic    "%{[23m%}"
    underline "%{[04m%}" no-underline "%{[24m%}"
    blink     "%{[05m%}" no-blink     "%{[25m%}"
    reverse   "%{[07m%}" no-reverse   "%{[27m%}"
)

for color in {000..255}; do
    FG[$color]="%{[38;5;${color}m%}"
    BG[$color]="%{[48;5;${color}m%}"
done

# Show all 256 colors with color number
function spectrum_ls() {
  for code in {000..255}; do
    print -P -- "$code: %F{$code}Test%f"
  done
}

prompt_user_color="%{${fg[cyan]}%}"
prompt_dir_color="%{${fg_bold[red]}%}"
prompt_vcs_color=$FG[068]

PROMPT="$prompt_user_color%n@%m%{$reset_color%} $prompt_dir_color%~%%%{$reset_color%} "
PROMPT2="$prompt_dir_color%_%%%{$reset_color%} "
SPROMPT="$prompt_dir_color%r is correct? [n,y,a,e]:%{$reset_color%} "

if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
    debian_chroot_color=$FG[105]
    PROMPT="$debian_chroot_color($debian_chroot)%{$reset_color%} $PROMPT"
fi

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

autoload -Uz is-at-least
if is-at-least 4.3.7; then
    autoload -Uz vcs_info
    zstyle ':vcs_info:*' enable git svn hg bzr
    zstyle ':vcs_info:*' formats '%s@%b'
    zstyle ':vcs_info:*' actionformats '%s@%b|%a'
    zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:r%r'
    zstyle ':vcs_info:bzr:*' use-simple true

    if is-at-least 4.3.10; then
        zstyle ':vcs_info:git:*' check-for-changes true
        zstyle ':vcs_info:git:*' stagedstr "+"
        zstyle ':vcs_info:git:*' unstagedstr "-"
        zstyle ':vcs_info:git:*' formats '%s@%b %c%u'
        zstyle ':vcs_info:git:*' actionformats '%s@%b|%a %c%u'
    fi

    autoload add-zsh-hook
    function _update_vcs_info_msg() {
        psvar=()
        LANG=en_US.UTF-8 vcs_info
        [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
    }
    add-zsh-hook precmd _update_vcs_info_msg
    RPROMPT="%0(v|%F$prompt_vcs_color%1v%f|)%{$reset_color%}"
fi


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
HISTSIZE=10000
SAVEHIST=10000
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

alias s="screen -U"
alias sr="screen -U -D -R"
alias srr="screen -U -D -RR"
alias sls="screen -U -ls"

alias where="command -v"
alias j="jobs -l"
alias du="du -h"
alias df="df -h"
alias su="su -l"
alias sudo="sudo "
alias :q="exit"

$(which ack-grep > /dev/null 2>&1) && alias ack="ack-grep"

alias py="python"
alias pyb="pythonbrew"

alias g++03="g++ -Wall -Wextra"
alias g++11="g++ -Wall -Wextra -std=gnu++11"

if $(which tmux > /dev/null 2>&1); then
    function t() {
        if [[ -z $1 ]]; then
            tmux
        else
            tmux has -t $1 && tmux attach -t $1 || tmux new -s $1
        fi
    }
    function _t() {
        local -a sessions
        sessions=(${${(f)"$(command tmux list-sessions)"}/:[ $'\t']##/:})
        _describe -t sessions 'sessions' sessions "$@"
    }
    compdef _t t
    alias tls="tmux ls"
fi

# End {{{1
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

