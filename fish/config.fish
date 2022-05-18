### Env

function source_if
    set -l file $argv[1]
    if test -f $file
        source $file
    end
end

function has
    type $argv[1] > /dev/null 2>&1
end

fish_add_path ~/bin
fish_add_path ~/.krew/bin

if status is-login
    # homebrew
    if test -f '/opt/homebrew/bin/brew'
        eval "$(/opt/homebrew/bin/brew shellenv)"
    end

    # asdf
    source_if /opt/homebrew/opt/asdf/libexec/asdf.fish
end

if status is-interactive
    if has 'starship'
        starship init fish | source
    end
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

if has 'kubectl'
    abbr -a k 'kubectl'
end

if has 'kubectl-ctx'
    abbr -a kc 'kubectl ctx'
    abbr -a kn 'kubectl ns'
end

alias :q='exit'

