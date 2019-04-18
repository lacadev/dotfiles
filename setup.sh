#! /bin/bash

function install_if_min_release() {
  package=$1
  min_release=$2

  if [[ "$ubuntu_release" > "$min_release" || "$ubuntu_release" == "$min_release" ]]; then
    sudo apt install "$package" -y
  else
    echo "$package needs to be installed manually for Ubuntu < $min_release"
    echo "You are using Ubuntu $ubuntu_release"
  fi
}

dotfiles="$(realpath $0 | xargs dirname)"
sudo apt update
ubuntu_release="$(lsb_release -r | awk '{print $2}')"
[ ! -d $HOME/.config ] && mkdir $HOME/.config


#####################
#     DEV UTILS     #
#####################
sudo apt install software-properties-common -y
sudo apt update
sudo apt install git curl tldr -y
install_if_min_release "ripgrep" "18.10"
ln -s $dotfiles/.gitconfig ~/.gitconfig
ln -s $dotfiles/.gitignore_global ~/.gitignore_global


#####################
#   DESKTOP UTILS   #
#####################
# TODO: Install redshift spotify evince firefox
# TODO: Make soft link to redshift config
# TODO: Make it able to copy personal configs (Wireguard, fstab (smb share)),
# taking them from lpass-cli


#####################
#        ZSH        #
#####################
# Set up zsh
echo "Installing Zsh..."
sudo apt install zsh -y
# Copy .zshrc and .zprofile from dotfiles
ln -s $dotfiles/.zshrc ~/.zshrc
ln -s $dotfiles/.zprofile ~/.zprofile
# Change shell
chsh -s $(which zsh)
# Install OhMyZsh
echo "Installing OhMyZsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
echo "Installing OhMyZsh plugins..."
# Install zsh-syntax-highlighting plugin using OhMyZsh as the plugin manager
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# Install zsh-autosuggestions plugin using OhMyZsh as the plugin manager
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions


#####################
#       NVIM        #
#####################
# Set up neovim
# Copy .vimrc from dotfiles
ln -s $dotfiles/.config/nvim/init.vim ~/.config/nvim/init.vim
echo "Installing neovim..."
sudo add-apt-repository ppa:neovim-ppa/stable -y
sudo apt update
sudo apt install neovim -y
# Install Vim-Plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
[ ! -f ~/.vimrc ] && ln -s ~/.config/nvim/init.vim ~/.vimrc
# cp -r $dotfiles/.config/nvim $HOME/.config/ # Commented because we're not using colors
# Set up pynvim, needed for python plugins (https://github.com/neovim/pynvim)
sudo apt install gcc libpq-dev -y
sudo apt install python3-dev python3-pip python3-venv python3-setuptools python3-wheel -y
python3 -m venv ~/.config/nvim/venv
source ~/.config/nvim/venv/bin/activate
pip3 install wheel
pip3 install pynvim jedi
deactivate
# Install plugins
echo "Installing nvim plugins..."
nvim -es -u $HOME/.vimrc -i NONE -c "PlugInstall" -c "qa"


#####################
#       TMUX        #
#####################
# Set up tmux
echo "Installing tmux..."
sudo apt install tmux -y
# Install tpm (tmux plugin manager)
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
# Copy .tmux.conf from dotfiles
ln -s $dotfiles/.tmux.conf ~/.tmux.conf
# Install plugins (HAS TO BE RUN FROM INSIDE TMUX). The session is closed on finish
echo "Installing tmux plugins... (THIS USUALLY DOESN'T WORK)"
tmux new-session -d -s "temp1" $HOME/.tmux/plugins/tpm/bin/install_plugins
# Save neovim theme using tmuxline plugin to have tmux match it
echo "Installing tmux theme to match nvim's..."
mkdir -p $HOME/.tmux/tmuxline-themes
tmux new-session -d -s "temp3" nvim -es -u $HOME/.vimrc -i NONE -c "Tmuxline airline" -c "TmuxlineSnapshot ~/.tmux/tmuxline-themes/current-theme" -c "qa"


#####################
#       PYENV       #
#####################
echo "Installing pyenv..."
sudo apt-get install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
  libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
  xz-utils tk-dev libffi-dev liblzma-dev python-openssl
  curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash


#####################
#      DOCKER       #
#####################
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


#####################
#       LATEX       #
#####################
# Uncomment if LaTeX is needed
# apt install texlive-full latexmk bibclean -y
# ln -s $dotfiles/.latexmkrc ~/.latexmkrc


#####################
#       SHELL       #
#####################
# Ale knows to use it by default
sudo apt install shellcheck -y
# Testing for bash
git clone https://github.com/bats-core/bats-core.git /tmp/bats-core
cd /tmp/bats-core || exit
sudo ./install.sh /usr/bin


# TODO: Make all sections functions instead, so that we could pass arguments
# and just execute each function depending on the programs you want

echo "FINISHED! To finalize tmux config, pls run tmux and inside press [C-a]+I to install the plugins"
