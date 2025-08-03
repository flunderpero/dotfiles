# Find out who's listening.
# Input:
#   - $0 (optional): port
listening() {
    if [ $# -eq 0 ]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P
    elif [ $# -eq 1 ]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P | grep -i $1
    else
        echo "Usage: listening [pattern]"
    fi
}
