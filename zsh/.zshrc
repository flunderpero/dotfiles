# ---------- Basics for both, local and remote machines. ----------

autoload -Uz compinit && compinit
# Enable vi mode.
bindkey -v

# Do not kill background-tasks when exiting.
# See http://stackoverflow.com/questions/19302913/exit-zsh-but-leave-running-jobs-open
setopt nohup

# Aliases
alias ls="ls -G --color"
alias ll="ls -lagh"
alias ssh="ssh -A -X"
alias dps="docker ps"
alias k="kubectl"
alias kg="k get"
alias kgp="kg pods"
alias kgpe='kgp -o=custom-columns="NAMESPACE:.metadata.namespace,NAME:.metadata.name,STATUS:.status.phase,RESTARTS:.status.containerStatuses[0].restartCount,AGE:.metadata.creationTimestamp,REQUESTS_CPU:.spec.containers[*].resources.requests.cpu,REQUESTS_MEM:.spec.containers[*].resources.requests.memory,LIMITS_CPU:.spec.containers[*].resources.limits.cpu,LIMITS_MEM:.spec.containers[*].resources.limits.memory"'
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
alias pgrep="pgrep -f -l"
# Make watch expand aliases and preserve color output. BWT, the space at the end
# does the trick with expanding aliases.
# https://unix.stackexchange.com/questions/25327/watch-command-alias-expansion
alias watch='watch --color '

# History
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
alias history='history -t "%Y-%m-%d"'

# Directory stack (use `dirs` to get a list of the recently visited directories)
setopt AUTO_PUSHD 
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
# Select one of the directories on the stack to jump to.
local ccd_default_dirs=()
ccd() {
    local dir
    dir=$(
        (
            dirs -p;
            echo ${ccd_default_dirs} | tr ' ' '\n'
        ) | sort -u | fzf
    )
    if [[ -n $dir ]]; then
        cd "${dir/#\~/$HOME}"
    fi
}

# Completion
setopt MENU_COMPLETE                                                                  
setopt AUTO_LIST                                                                 
setopt COMPLETE_IN_WORD
zstyle ':completion:*' menu select
# Colors for files and directory
zstyle ':completion:*:*:*:*:default' list-colors ${(s.:.)LS_COLORS}

# Prompt
setopt PROMPT_SUBST
local prompt_ret_status="%(?:%F{green%}:%F{red})❯ %f"
export PROMPT='%F{blue}%~%f'$'\n''${prompt_ret_status}'
# The `\e[1A]` / `\e[1B]` first moves the cursor one line up and then one line down.
# This is a workaround to make sure that the right prompt is on the first line of our
# left side prompt. (It spans two lines.)
export RPROMPT='%{'$'\e[1A''%}%F{blue}%*%f%{'$'\e[1B''%}'

# ---------- ZSH widgets ----------

# ^P copy the output of the last command
zmodload -i zsh/parameter
insert-last-command-output() {
    LBUFFER+="$(eval $history[$((HISTCMD-1))])"
}
zle -N insert-last-command-output
bindkey "^P" insert-last-command-output

# ^R will start searching with what's already typed on the current line.
# (Adapted from https://unix.stackexchange.com/a/588742)
# We will use `fzf` to search the history eventually (see further down)
# but this is still good for SSH sessions.
history-incremental-search-backward() {
    local saved_BUFFER=$BUFFER
    BUFFER=
    zle .$WIDGET -- $saved_BUFFER
}
zle -N history-incremental-search-backward
bindkey "^R" history-incremental-search-backward

# ---------- Remote SSH session ----------

if [ -n "$SSH_CLIENT" ] ; then
    # If this is a SSH session, we stop here.
    export RPROMPT='%{'$'\e[1A''%}%* %F{yellow}%m%f%{'$'\e[1B''%}'
    [ -f "$HOME/.zprofile" ] && source "$HOME/.zprofile"
    echo "I am a remote machine."
    return 0
fi

# ---------- Personal workstation settings ----------

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

# Custom aliases
alias top=htop
alias vi="nvim"
alias vim="nvim"

# Homebrew
eval "$($HOMEBREW_HOME/bin/brew shellenv)"
PATH="$HOMEBREW_HOME/opt/protobuf@3/bin:$PATH"
export HOMEBREW_NO_AUTO_UPDATE=1

# Prefer the GNU versions over the MacOS built-ins.
# (https://gist.github.com/skyzyx/3438280b18e4f7c490db8a2a2ca0b9da)
for bindir in "${HOMEBREW_HOME}/opt/"*"/libexec/gnubin"; do export PATH=$bindir:$PATH; done
for bindir in "${HOMEBREW_HOME}/opt/"*"/bin"; do export PATH=$bindir:$PATH; done
for mandir in "${HOMEBREW_HOME}/opt/"*"/libexec/gnuman"; do export MANPATH=$mandir:$MANPATH; done
for mandir in "${HOMEBREW_HOME}/opt/"*"/share/man/man1"; do export MANPATH=$mandir:$MANPATH; done

# Sourcing command output - like many tools require us to do these days - can be
# slow, so use this function to cache the output.
# If the temporary file exists, it will be sourced immediately. If not, it will
# be created first by running the given command (`$2..$x`).
# After that the command will be run in the background and the temporary file
# will be created again, so that on the next run, we will have the newest 
# completions.
#
# @param $1 temporary file
# @param $2.. the command and its parameters to run
function source_cached_command() {
    local tmp_file=$1
    shift
    if [ ! -e "$tmp_file" ]; then
        eval "$@" > $tmp_file
    fi
    source $tmp_file
    # The `()` around the command execute it in a sub-shell, so we don't
    # see the process messages.
    ("$@" > $tmp_file &)
}

# fzf
export FZF_CTRL_T_OPTS="
    --preview 'bat -n --color=always {}'
    --bind 'ctrl-p:change-preview-window(50%|hidden|)'
    --bind 'ctrl-h:reload(fd --type f --follow --strip-cwd-prefix --hidden --no-ignore --exclude .git)'
    --header 'CTRL-H: Show hidden files'"
export FZF_CTRL_R_OPTS="
    --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
    --header 'CTRL-Y: Copy into clipboard'"
export FZF_COMPLETION_OPTS='--border=rounded --info=default --height=90%'
export FZF_DEFAULT_COMMAND='fd --type f --follow --strip-cwd-prefix --hidden --exclude .git --exclude node_modules'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
source <(fzf --zsh)
_fzf_compgen_path() {
  fd --follow --hidden --exclude .git --exclude node_modules . "$1"
}
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude .git --exclude node_modules . "$1"
}

# Default directories for our `ccd` command (see above).
ccd_default_dirs=(
    "~/Downloads"
    "~/src"
    "~/src/pero"
    "~/src/pero/cling-main"
    "~/src/pero/klar"
    "~/.dotfiles"
)

# ---------- Languages and tools ----------

# Google Cloud SDK
source "$HOME/src/google-cloud-sdk/path.zsh.inc"
source "$HOME/src/google-cloud-sdk/completion.zsh.inc"
source_cached_command "/tmp/kubectl_completion" kubectl completion zsh
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
# https://cloud.google.com/iap/docs/using-tcp-forwarding#increasing_the_tcp_upload_bandwidth
export CLOUDSDK_PYTHON_SITEPACKAGES=1

# Stern autocompletion
source_cached_command "/tmp/stern_completion" stern --completion=zsh

# Java and Android Studio
export JAVA_HOME="$HOMEBREW_HOME/opt/openjdk"
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"

# Python
source_cached_command "/tmp/pyenv_init" pyenv init -
export PYTHONIOENCODING="utf8"

# Go
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
export GOTOOLCHAIN="auto"

# Node Version Manager (nvm)
# Since nvm has such a high startup time (> 0.5s) we do not load it by default.
# You have to run `use_nvm` if you want to change node versions.
export NVM_DIR="$HOME/.nvm"
export NODE_VERSION="22.2.0"
local use_nvm_loaded=
function use_nvm() {
    if [ -z "${use_nvm_loaded}" ]; then
        [ -s "$HOMEBREW_HOME/opt/nvm/nvm.sh" ] && . "$HOMEBREW_HOME/opt/nvm/nvm.sh"
        [ -s "$HOMEBREW_HOME/opt/nvm/etc/bash_completion.d/nvm" ] \
            && . "$HOMEBREW_HOME/opt/nvm/etc/bash_completion.d/nvm"
        nvm use --silent $NODE_VERSION
        use_nvm_loaded="1"
    fi
}
# Because we don't want to load nvm we hard-code the PATH to the node version we
# usually want.
PATH=$PATH:$HOME/.nvm/versions/node/v$NODE_VERSION/bin

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# Bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Rust
export PATH="$PATH:$HOME/.cargo/bin"

# ---------- Configure our main dev project at the time. ----------

CLING_HOME="$HOME/src/pero/cling-main"
[ -f "$CLING_HOME/.profile" ] && source "$CLING_HOME/.profile"
