#/bin/bash
set -e

dotfiles=$(realpath $(dirname $0))

# zsh
[ -d ~/.oh-my-zsh ] || \
    curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
rm -f ~/.zshrc
rm -f ~/.p10k.zsh
ln -s $dotfiles/zsh/.zshrc ~/
ln -s $dotfiles/zsh/.p10k.zsh ~/
[ -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ] || \
    git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git \
    ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
[ -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ] || \
    git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions \
    ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
[ -d ~/.oh-my-zsh/custom/themes/powerlevel10k ] || \
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    ~/.oh-my-zsh/custom/themes/powerlevel10k

mkdir -p ~/.config
rm -f ~/.config/kitty
ln -s $dotfiles/kitty ~/.config/
rm -f ~/.gitconfig
ln -s $dotfiles/git/.gitconfig ~/
if [ "$(uname -s)" = "Darwin" ] ; then
    rm -f ~/.aerospace.toml
    ln -s $dotfiles/osx/.aerospace.toml ~/
    rm -f ~/.config/karabiner
    ln -s $dotfiles/osx/karabiner ~/.config/
    source $dotfiles/install.brew.sh
    source $dotfiles/install.nvim.sh
    source $dotfiles/install.dev.sh
    source $dotfiles/install.tmux.sh
    source $dotfiles/install.rust.sh
fi
