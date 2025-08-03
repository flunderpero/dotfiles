# [[ VI mode ]]

set -o vi

# [[ History ]]

HISTCONTROL=ignoreboth:erasedups
HISTSIZE=10000
HISTFILESIZE=10000
shopt -s histappend  
# Arrow up/down to search history for commands matching what's typed.
bind '"\e[A": history-substring-search-backward'
bind '"\e[B": history-substring-search-forward'

# [[ Completion ]]

if [[ -r /opt/homebrew/etc/profile.d/bash_completion.sh ]]; then
  . /opt/homebrew/etc/profile.d/bash_completion.sh
elif [[ -r /etc/bash_completion ]]; then
  . /etc/bash_completion
elif [[ -r /usr/share/bash-completion/bash_completion ]]; then
  . /usr/share/bash-completion/bash_completion
fi
bind 'set show-all-if-ambiguous on'
bind 'set completion-ignore-case on'

# [[ Prompt ]]

PROMPT_COMMAND=__prompt

__prompt() {
    local exit=$?
    local red="\[\033[0;31m\]"
    local green="\[\033[0;32m\]"
    local blue="\[\033[0;34m\]"
    local colrst="\[\033[0m\]"
    if [[ $exit == 0 ]]; then
        exit=$green
    else
        exit=$red
    fi
    local rprompt=$(__rprompt)
    local date=$(date +%T)
    local pwd="${PWD/#$HOME/~}"
    local roffset=$((${COLUMNS:-80} - ${#pwd} - ${#date} - ${#rprompt} - 2))
    if [[ $rprompt =~ "live" ]] ; then
        rprompt="$red$rprompt$blue"
    fi
    local right="$rprompt $(date +%T)"
    local rspace=$(printf "%${roffset}s")

    PS1=$"$blue$pwd$colrst$rspace$blue$right$colrst\n${exit}❯ $colrst"
}

# [[ SSH session ends here. ]]

if [ -n "$SSH_CLIENT" ] ; then
    __rprompt() {
        hostname
    }
    [ -f "$HOME/.bash_profile" ] && ! grep -q ".bashrc" "$HOME/.bash_profile" && source "$HOME/.bash_profile"
    [[ $- == *i* ]] && echo "I am a remote machine."
    return 0
fi

# [[ Path ]]

# We want to be very specific about our $PATH. 
# That's why we start from an empty PATH.
PATH="$HOME/src/google-cloud-sdk/bin"
PATH="$PATH:/usr/local/opt/openjdk/bin"
PATH="$PATH:$HOME/src/google-cloud-sdk/bin"
PATH="$PATH:/usr/lib64/qt-3.3/bin"
PATH="$PATH:$HOME/.local/bin"
PATH="$PATH:$HOME/bin"
PATH="$PATH:/usr/local/bin"
PATH="$PATH:/usr/local/sbin"
PATH="$PATH:/usr/bin"
PATH="$PATH:/usr/sbin"
PATH="$PATH:/bin"
PATH="$PATH:/sbin"
PATH="$PATH:$HOME/.krew/bin"

# [[ Custom source command ]]

# Sourcing command output - like many tools require us to do these days - can be
# slow, so use this function to cache the output.
#
# Input:
#   $@ - the command and its parameters to run
source_cached_command() {
    local tmp_file=/tmp/source_cached_command_$(echo "$@" | sha256sum | awk '{ print $1 }')
    if [ ! -e "$tmp_file" ]; then
        eval "$@" > $tmp_file
    fi
    source $tmp_file
    # The `()` around the command execute it in a sub-shell, so we don't
    # see the process messages.
    ("$@" > $tmp_file &)
}

# [[ Homebrew ]]

export HOMEBREW_HOME="/opt/homebrew"
eval "$($HOMEBREW_HOME/bin/brew shellenv)"
PATH="$HOMEBREW_HOME/opt/protobuf@3/bin:$PATH"
export HOMEBREW_NO_AUTO_UPDATE=1

# Prefer the GNU versions over the MacOS built-ins.
# (https://gist.github.com/skyzyx/3438280b18e4f7c490db8a2a2ca0b9da)
for bindir in "${HOMEBREW_HOME}/opt/"*"/libexec/gnubin"; do export PATH=$bindir:$PATH; done

# [[ Prompt cont'd ]]

# Add the active gcloud-project to the right prompt. We need to directly access
# the gcloud config files because the actual `gcloud` command is quite slow.
__rprompt() {
    local f="$HOME/.config/gcloud/configurations/config_$(cat ~/.config/gcloud/active_config)"
    cat "$f" | awk -F "=" '/project/ {print $2}' | tr -d ' '
}

# Verify (asynchronously!) that our workaround still works.
# The `()` execute the command in a sub-shell so we don't see the process messages.
( 
    if [[ $(__rprompt) != $(gcloud -q config get-value project) ]] ; then
        echo "The rprompt '__rprompt()' is wrong! Check your shell config!"
    fi & 
)

# [[ fzf ]]

# We are using `fd` instead of `find`.
export FZF_DEFAULT_COMMAND='fd --type f --follow --strip-cwd-prefix --hidden --exclude .git --exclude node_modules'
export FZF_CTRL_T_OPTS="
    --preview 'bat -n --color=always {}'
    --bind 'ctrl-p:change-preview-window(50%|hidden|)'
    --bind 'ctrl-h:reload(fd --type f --follow --strip-cwd-prefix --hidden --no-ignore --exclude .git)'
    --header 'CTRL-H: Show hidden files'"
export FZF_CTRL_R_OPTS="
    --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
    --header 'CTRL-Y: Copy into clipboard'"
export FZF_COMPLETION_OPTS='--border=rounded --info=default --height=90%'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
eval "$(fzf --bash)"

_fzf_compgen_path() {
  fd --follow --hidden --exclude .git --exclude node_modules . "$1"
}
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude .git --exclude node_modules . "$1"
}

# [[ Misc ]]

export LANG=en_US.UTF-8
export SSH_KEY_PATH="~/.ssh/id_rsa"

# Aliases and functions
[ -f "$HOME/.bash_aliases" ] && source "$HOME/.bash_aliases"
[ -f "$HOME/.bash_functions" ] && source "$HOME/.bash_functions"

# [[ Languages and tools ]]

# Google Cloud SDK
source "$HOME/src/google-cloud-sdk/path.bash.inc"
source "$HOME/src/google-cloud-sdk/completion.bash.inc"
source_cached_command kubectl completion bash
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
# https://cloud.google.com/iap/docs/using-tcp-forwarding#increasing_the_tcp_upload_bandwidth
export CLOUDSDK_PYTHON_SITEPACKAGES=1

# Stern autocompletion
source_cached_command stern --completion=bash

# Java and Android Studio
export JAVA_HOME="$HOMEBREW_HOME/opt/openjdk"
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"

# Python
source_cached_command pyenv init -
export PYTHONIOENCODING="utf8"

# OCaml
test -r '/Users/pero/.opam/opam-init/init.sh' && . '/Users/pero/.opam/opam-init/init.sh' > /dev/null 2> /dev/null || true

# Go
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
export GOTOOLCHAIN="auto"

# Node Version Manager (nvm)
# Since nvm has such a high startup time (> 0.5s) we do not load it by default.
# You have to run `use_nvm` if you want to change node versions.
export NVM_DIR="$HOME/.nvm"
export NODE_VERSION="22.2.0"
use_nvm_loaded=
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
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Deno
export PATH="$PATH:$HOME/.deno/bin"

# Rust
export PATH="$PATH:$HOME/.cargo/bin"

# [[ Configure our main dev project at the time. ]]

CLING_HOME="$HOME/src/pero/cling-main"
[ -f "$CLING_HOME/.profile" ] && source "$CLING_HOME/.profile"
