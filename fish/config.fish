### Env

function source_if
    set -l file $argv[1]
    if test -f $file
        source $file
    end
end

function add_path_if
    set -l dir $argv[1]
    if test -d $dir
        fish_add_path $dir
    end
end

function has
    type $argv[1] > /dev/null 2>&1
end

fish_add_path ~/bin
fish_add_path ~/.krew/bin

if status is-interactive
    # starship
    if has 'starship'
        starship init fish | source
    end

    # homebrew
    if test -f '/opt/homebrew/bin/brew'
        eval "$(/opt/homebrew/bin/brew shellenv)"
    end
    if test -f '/usr/local/bin/brew'
        eval "$(/usr/local/bin/brew shellenv)"
    end

    # rtx
    if has 'rtx'
        rtx activate fish | source
    end

    # Android Studio
    add_path_if ~/Library/Android/sdk/platform-tools

    # golang
    add_path_if ~/go/bin
end


## Abbr & Alias

if has 'exa'
    alias ls='exa'
    alias tree='exa --tree'
end

abbr -a l 'ls -al'

if has 'tmux'
    abbr -a t 'tmux new-session -s'
    abbr -a ta 'tmux attach-session'
    abbr -a tls 'tmux list-sessions'
end

if has 'podman'
    alias docker='podman'
end

if has 'kubectl'
    abbr -a k 'kubectl'
end

if has 'kubectl-ctx'
    abbr -a kc 'kubectl ctx'
    abbr -a kn 'kubectl ns'
end

alias :q='exit'
