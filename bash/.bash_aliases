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
alias top=htop
alias vi="nvim"
alias vim="nvim"
