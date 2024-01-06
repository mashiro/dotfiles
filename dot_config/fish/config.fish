# Settings

if test -z "$__DEFAULT_PATH"
    set -gx __DEFAULT_PATH $PATH
end

set -gx PATH $__DEFAULT_PATH
set -gx XDG_CONFIG_HOME $HOME/.config


# Utils

function add_path_if
    set -l dir $argv[1]
    if test -d $dir
        set -gx PATH $dir $PATH
    end
end

function source_if
    set -l file $argv[1]
    if test -f $file
        source $file
    end
end

function has
    type $argv[1] >/dev/null 2>&1
end


# Paths

## Rancher Desktop
add_path_if ~/.rd/bin

## Android Studio
add_path_if ~/Library/Android/sdk/platform-tools

## Google Cloud
source_if ~/.local/share/google-cloud-sdk/path.fish.inc

## golang
add_path_if ~/go/bin

## Homebrew
if test -f /opt/homebrew/bin/brew
    eval "$(/opt/homebrew/bin/brew shellenv)"
else if test -f /usr/local/bin/brew
    eval "$(/usr/local/bin/brew shellenv)"
end

## mise
if test -f ~/.local/bin/mise
    set -l mise ~/.local/bin/mise
    $mise activate fish | source
    $mise hook-env -s fish | source
    $mise complete fish | source
end

## krew
add_path_if ~/.krew/bin

## local
add_path_if ~/.local/bin


# Prompt

## Starship
if has starship && status is-interactive
    starship init fish | source
end


# Abbr & Alias

if has eza
    alias ls='eza --time-style=relative'
    alias tree='eza --tree'
end

abbr -a l 'ls -al'

if has nvim
    alias vim="nvim"
    set -gx EDITOR nvim
end

if has chezmoi
    chezmoi completion fish | source
end

if has tmux
    abbr -a t 'tmux new-session -A -s'
    abbr -a ta 'tmux attach-session -t'
    abbr -a tls 'tmux list-sessions'
end

if has podman
    alias docker='podman'
end

if has kubectl
    abbr -a k kubectl
end

if has kubectl-ctx
    abbr -a kc 'kubectl ctx'
    abbr -a kn 'kubectl ns'
end

if has k9s
    alias k9s='LANG=C.UTF-8 command k9s'
end

alias :q='exit'
