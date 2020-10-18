#! /bin/bash

function info() {
  echo "INFO: ${1}"
}

function install_if_min_release() {
  package=$1
  min_release=$2

  if [[ "$UBUNTU_RELEASE" > "$min_release" || "$UBUNTU_RELEASE" == "$min_release" ]]; then
    sudo apt install "$package" -y
  else
    echo "$package needs to be installed manually for Ubuntu < $min_release"
    echo "You are using Ubuntu $UBUNTU_RELEASE"
  fi
}

function install_common() {
  sudo apt install software-properties-common -y
  sudo apt update
  sudo apt install curl -y
}

function install_dev_utils() {
  info "Installing dev utils..."
  sudo apt install tldr -y
  install_if_min_release "ripgrep" "18.10"
}

function install_git() {
  info "Installing git..."
  sudo apt install git -y
  # Copy .gitconfig instead of symlink because user depends on computer
  # TODO: Create a a file with the git user and import from gitconfig.
  # Then make gitconfig a symlink and copy just the user file instead
  cp $DOTFILES/.gitconfig ~/.gitconfig
  ln -s $DOTFILES/.gitignore_global ~/.gitignore_global
}

function install_zsh() {
  info "Installing Zsh..."
  sudo apt install zsh -y
  # Change shell
  chsh -s $(which zsh)
  # Install OhMyZsh
  info "Installing OhMyZsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  info "Installing OhMyZsh plugins..."
  # Install zsh-syntax-highlighting plugin using OhMyZsh as the plugin manager
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  # Install zsh-autosuggestions plugin using OhMyZsh as the plugin manager
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  # Link configs AFTER installing oh-my-zsh becuase it replaces whatever was there
  ln -s -f $DOTFILES/.zshrc ~/.zshrc
  ln -s -f $DOTFILES/.zprofile ~/.zprofile
}

function install_neovim() {
  # Copy .vimrc from dotfiles
  info "Installing neovim..."
  sudo add-apt-repository ppa:neovim-ppa/stable -y
  sudo apt update
  sudo apt install neovim -y
  # Link configs after installation in case they are overwritten
  mkdir -p ~/.config/nvim
  ln -s -f $DOTFILES/.config/nvim/init.vim ~/.config/nvim/init.vim
  ln -s -f $DOTFILES/.config/nvim/init.vim ~/.vimrc
  # Install Vim-Plug
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  # Set up pynvim, needed for python plugins (https://github.com/neovim/pynvim)
  sudo apt install gcc libpq-dev -y
  sudo apt install python3-dev python3-pip python3-venv python3-setuptools python3-wheel -y
  python3 -m venv ~/.config/nvim/venv
  source ~/.config/nvim/venv/bin/activate
  pip3 install wheel
  pip3 install pynvim jedi
  deactivate
  # Install plugins
  info "Installing neovim plugins..."
  nvim -es -u $HOME/.vimrc -i NONE -c "PlugInstall" -c "qa"
  ln -s -f $DOTFILES/.config/nvim/coc-settings.json ~/.config/nvim/coc-settings.json
  info "Going to install NodeJS as a coc.nvim dependancy..."
  install_nodejs
}

function install_tmux() {
  info "Installing tmux..."
  sudo apt install tmux -y
  # Copy .tmux.conf from dotfiles
  ln -s -f $DOTFILES/.tmux.conf ~/.tmux.conf
  # Save neovim theme using tmuxline plugin to have tmux match it
  if type nvim > /dev/null; then
    info "Installing tmux theme to match nvim's..."
    mkdir -p $HOME/.tmux/tmuxline-themes
    tmux new-session -d -s "temp-session" \
      nvim -es -u $HOME/.vimrc -i NONE \
        -c "Tmuxline airline" \
        -c "TmuxlineSnapshot ~/.tmux/tmuxline-themes/current-theme" \
        -c "qa"
  fi
}

function install_pyenv() {
  info "Installing pyenv..."
  git clone https://github.com/pyenv/pyenv.git ~/.pyenv
  # Dependencies needed to build python versions
  sudo apt install --no-install-recommends -y \
    make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
    libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev \
    libxmlsec1-dev libffi-dev liblzma-dev
}

function install_docker() {
  # This whole thing is untested because DinD needs either some changes in the testing image
  # or just using a DinD image to test this. Might do in the future.
  info "Installing docker..."
  sudo apt install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    -y
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
  sudo apt update
  sudo apt install docker-ce docker-ce-cli containerd.io -y
  sudo usermod -aG docker "$(whoami)"
}

function install_latex() {
  # Untested because I hope I never have to use this again
  info "Installing latex..."
  apt install texlive-full latexmk bibclean -y
  ln -s $DOTFILES/.latexmkrc ~/.latexmkrc
}

function install_nodejs() {
  info "Installing nodejs"
  sudo apt install nodejs npm -y
  # Potentially install nvm in the future
  # to manage node versions
}

function install_go() {
  info "Installing go..."
  sudo add-apt-repository ppa:longsleep/golang-backports -y
  sudo apt update
  sudo apt install golang-go -y
}

function install_java() {
  # TODO: Implement
  echo "Not implemented yet"
}

function install_scala() {
  # TODO: Implement
  echo "Not implemented yet"
}
