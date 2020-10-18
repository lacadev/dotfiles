#! /bin/bash

DOTFILES="$(realpath $0 | xargs dirname)"
UBUNTU_RELEASE="$(cat /etc/os-release | grep VERSION_ID | sed 's/^.*"\(.*\)".*$/\1/')"
[ ! -d $HOME/.config ] && mkdir $HOME/.config

source "$DOTFILES/helpers.sh"

install_common
install_git
install_dev_utils
install_zsh
install_neovim
install_tmux
install_pyenv
install_docker
install_nodejs
install_go

## Commented out because these are usually not needed
# install_latex

ln -s $DOTFILES/scripts ~/scripts
