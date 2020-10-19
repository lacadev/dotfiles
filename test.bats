function setup_file() {
  $BATS_TEST_DIRNAME/setup.sh
}

@test "dev utils are installed correctly" {
  # Check tldr is installed
  tldr -v > /dev/null
  # Check ripgrep is installed if Ubuntu version > 18.10
  if [[ "$UBUNTU_RELEASE" > "18.10" ]]; then
    rg --version > /dev/null
  fi
}

@test "git is installed correctly" {
  # Check git is installed
  git --version > /dev/null
  # Check that the global gitconfig was copied, not sym linked
  [ -f $HOME/.gitconfig ] && [ ! -L $HOME/.gitconfig ]
  # Check that the global gitignore was sym linked
  [ -L $HOME/.gitignore_global ] && [ -e $HOME/.gitignore_global ]
}

@test "zsh is installed correctly" {
  # Check zsh is installed
  zsh --version > /dev/null
  # Check that symlinks to configs have been created
  [ -L $HOME/.zshrc ] && [ -e $HOME/.zshrc ]
  [ -L $HOME/.zprofile ] && [ -e $HOME/.zprofile ]
  # Check that ZSH is the default shell
  [ "$SHELL" == "$(which zsh)" ]
  # Check that oh-my-zsh is installed
  [ "$(ls $HOME/.oh-my-zsh)" ]
  # Check that oh-my-zsh plugins are installed
  # by checking the plugins foler is not empty
  # (excluding the example plugin that comes preinstalled)
  [ "$(ls $HOME/.oh-my-zsh/custom/plugins | grep -v example)" ]
}

@test "neovim is installed correctly" {
  # Check neovim is installed
  nvim -v > /dev/null
  # Check that symlinks to configs have been created
  [ -L $HOME/.vimrc ] && [ -e $HOME/.vimrc ]
  [ -L $HOME/.config/nvim/init.vim ] && [ -e $HOME/.config/nvim/init.vim ]
  # Check python3 virtualenv is correct
  source $HOME/.config/nvim/venv/bin/activate \
    && pip3 show pynvim > /dev/null \
    && pip3 show jedi > /dev/null \
    && deactivate
  # Check plugins are installed by checking
  # plugin folder is not empty
  [ "$(ls $HOME/.vim/plugged)" ]
  # Check that nodejs was installed correctly (coc.nvim dependancy)
  node -v > /dev/null
}

@test "tmux is installed correctly" {
 # Check tmux is installed
 tmux -V > /dev/null
 # Check that a symlink to the config has been created
 [ -L $HOME/.tmux.conf ] && [ -e $HOME/.tmux.conf ]
 # Check that plugins are installed correctly, apart from tpm
 [ "$(ls $HOME/.tmux/plugins | grep -v tpm)" ]
 # Check that if neovim is installed, tmux has a theme
 if command -v nvim; then
  [ -f ~/.tmux/tmuxline-themes/current-theme ]
 fi
}

@test "pyenv is installed correctly" {
 NEW_PYTHON_VERSION="3.8.1"
 # Point directly to pyenv binary because it's not in the path
 # until we use zsh
 PYENV="$HOME/.pyenv/bin/pyenv"
 # Check pyenv is installed
 $PYENV -v > /dev/null
 # Check that a new python version can be installed
 $PYENV install "$NEW_PYTHON_VERSION" > /dev/null
 # Check that the new version can be set
 $PYENV global "$NEW_PYTHON_VERSION"
 [ "$($PYENV global)" == "$NEW_PYTHON_VERSION" ]
}

@test "docker is installed correctly" {
  # Check docker is installed
  docker -v > /dev/null
  # Not testing anything else to avoid messing with DinD
}

@test "latex is installed correctly" {
  skip "I refuse to test this because I refuse to use LaTeX"
}

@test "nodejs is installed correctly" {
  # Check nodejs is installed
  node -v > /dev/null
}

@test "go is installed correctly" {
  # Check go is installed
  go version > /dev/null
}
