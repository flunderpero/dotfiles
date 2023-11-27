# ---
# Oh-my-zsh and Powerlevel10k configuration
# ---

# Enable Powerlevel10k instant prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
if [ -z "$SSH_CLIENT" ]; then
    ZSH_THEME="powerlevel10k/powerlevel10k"
fi
HYPHEN_INSENSITIVE="true"
DISABLE_AUTO_UPDATE="true"
HIST_STAMPS="yyyy-mm-dd"
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS

plugins=(git history-substring-search zsh-syntax-highlighting)

source "$ZSH/oh-my-zsh.sh"
autoload -Uz compinit && compinit
[ -f "$HOME/.p10k.zsh" ] && source "$HOME/.p10k.zsh"

# ---
# Configuration
# ---

# Do not kill background-tasks when exiting.
# See http://stackoverflow.com/questions/19302913/exit-zsh-but-leave-running-jobs-open
setopt nohup

# Aliases
alias ll="ls -lagh"
alias ssh="ssh -A -X"
alias dps="docker ps"
alias k="kubectl"
alias kg="k get"
alias kgp="kg pods"
alias kgpw="watch -n 1 kubectl get pods"
alias kgn="kg nodes"
alias kgnw="watch -n 1 kubectl get nodes"
alias kgd="kg deployment"
alias kgdw="watch -n 1 kubectl get deployments"
alias kl="kubectl logs --tail 100 -f"
alias ffprobe="ffprobe -v fatal -print_format json -show_format -show_streams"
# Ignore invalid lines in JSON.
alias jqi="jq -R 'fromjson?' -S"
alias jq="jq -S"
# The alias 'gm' for 'git merge' conflicts with GraphicsMagick.
unalias gm
# Make watch expand aliases.
# https://unix.stackexchange.com/questions/25327/watch-command-alias-expansion
alias watch='watch --color '

# Git aliases
git config --global alias.co checkout
git config --global alias.cm commit
git config --global alias.st status
git config --global alias.br branch

if [ -n "$SSH_CLIENT" ] ; then
    # If we are in a remote session, we stop here.
    export PROMPT='%{$fg[cyan]%}%c ${ret_status}%{$reset_color%}'
    export RPROMPT='[%{$fg[yellow]%}${HOSTNAME}%{$fg[blue]%}]%{$reset_color%}'
    [ -f "$HOME/.zprofile" ] && source "$HOME/.zprofile"
    echo "I am a remote machine."
    return 0
fi

# ---
# Personal workstation settings
# ---

export LANG=en_US.UTF-8
export SSH_KEY_PATH="~/.ssh/id_rsa"
export HOMEBREW_HOME="/usr/local"
[ -d "/opt/homebrew" ] && export HOMEBREW_HOME="/opt/homebrew"

# We want to be very specific about our $PATH.
PATH="$HOME/src/google-cloud-sdk/bin"
PATH="$PATH:/usr/local/opt/openjdk/bin"
PATH="$PATH:$HOME/src/google-cloud-sdk/bin"
PATH="$PATH:/usr/lib64/qt-3.3/bin"
PATH="$PATH:$HOME/.local/bin"
PATH="$PATH:$HOME/bin"
PATH="$PATH:$HOME/.deno/bin"
PATH="$PATH:/usr/local/bin"
PATH="$PATH:/usr/local/sbin"
PATH="$PATH:/usr/bin"
PATH="$PATH:/usr/sbin"
PATH="$PATH:/bin"
PATH="$PATH:/sbin"
PATH="$PATH:$HOME/.krew/bin"

# Homebrew
eval "$($HOMEBREW_HOME/bin/brew shellenv)"
PATH="$HOMEBREW_HOME/opt/protobuf@3/bin:$PATH"
export HOMEBREW_NO_AUTO_UPDATE=1
# We want to use the GNU versions of most commands.
# (https://gist.github.com/skyzyx/3438280b18e4f7c490db8a2a2ca0b9da)
source $HOME/.dotfiles/zsh/.zsh_gnu

# Google Cloud SDK
source "$HOME/src/google-cloud-sdk/path.zsh.inc"
source "$HOME/src/google-cloud-sdk/completion.zsh.inc"
source <(kubectl completion zsh)
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# Stern autocompletion
source <(stern --completion=zsh)

# Java and Android Studio
export JAVA_HOME="$HOMEBREW_HOME/opt/openjdk"
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"

# Python
pyenv global 3.11.1
eval "$(pyenv init -)"
eval "$(pyenv init --path)"
export PYTHONIOENCODING="utf8"

# Node Version Manager (nvm)
export NVM_DIR="$HOME/.nvm"
[ -s "$HOMEBREW_HOME/opt/nvm/nvm.sh" ] && . "$HOMEBREW_HOME/opt/nvm/nvm.sh"
[ -s "$HOMEBREW_HOME/opt/nvm/etc/bash_completion.d/nvm" ] \
    && . "$HOMEBREW_HOME/opt/nvm/etc/bash_completion.d/nvm"
nvm use --silent 18

# Bun
[ -s "/Users/pero/.bun/_bun" ] && source "/Users/pero/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Rust
export PATH="$PATH:$HOME/.cargo/bin"

# Custom aliases
alias top=htop
alias vi="nvim"
alias vim="nvim"

# Configure our main dev project at the time.
CLING_HOME="$HOME/src/pero/cling-main"
[ -f "$CLING_HOME/.zprofile" ] && source "$CLING_HOME/.zprofile"
