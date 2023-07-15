# Auto-completion
autoload -U compinit && compinit

# Syntax highlighting
source "$(brew --prefix zsh-syntax-highlighting)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Autocomplete stuff
source "$(brew --prefix zsh-autosuggestions)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Chain this with long running commands to hear a bell upon completion
function bell() {
    echo -e "\a"
}

function json() {
    local filename="$1"

    if [[ -f "$filename" ]]; then
        cat "$filename" | python3 -m json.tool | less
    else
        echo "File not found: $filename"
    fi
}

function h() {
    local search="$@"
    ag --nonumbers "${search}" "$HOME/.zsh_history" | sort -u
}

function ff() {
    find . -type f -name "*$@*" 2>/dev/null
}

alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias df='df -h'
alias du='du -h'

alias ll="ls -l"
alias lh="ls -ltrh"
alias zshrc="vim ~/.zshrc"
alias sz="source ~/.zshrc"
alias venv="python3 -m venv ./.venv && source ./.venv/bin/activate"
alias svenv="source ./.venve/bin/activate"
alias git_branch="git branch | grep \"*\""

setopt HIST_IGNORE_SPACE
setopt hist_ignore_space
setopt share_history
setopt autocd
setopt inc_append_history
setopt interactive_comments
setopt notify
setopt correct_all
setopt extended_glob

export HISTSIZE=10000000
export HISTFILE="$HOME/.zsh_history"
export SAVEHIST=10000000

# AWS cli
alias aws_identity="aws sts get-caller-identity"
