export PATH=$HOME/bin:/usr/local/bin:$PATH
# Python libraries like awscli
export PATH=$HOME/.local/bin:$PATH
# Snap
[ -x "$(command -v snap)" ] && export PATH=/snap/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME='robbyrussell'
# source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# DEFAULT_USER=$(whoami)

plugins=(zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
export LC_ALL=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
   export EDITOR='nvim'
fi

# Load pyenv config if installed
if [ -x "$(command -v pyenv)" ]; then 
  source $HOME/.config/zsh/pyenv.sh
fi
# Load jenv config if installed
source $HOME/.config/zsh/jenv.sh

# iTerm2 zsh integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Have a look at https://stackoverflow.com/questions/12018783/how-to-set-iterm2-tab-title-to-that-of-a-running-tmux-session-name
# for more info on terminal tab names
DISABLE_AUTO_TITLE="true"

# ALIASES
alias wisdom="fortune | cowsay | lolcat"
alias gpuTemp="watch --color -t -n 2 ~/.scripts/gputemp.sh"
alias listLogins="watch --color -t -n 2 ~/.scripts/listLogins.sh"
alias vim='nvim'
alias genPythonTags='ctags -R --fields=+l --languages=python --python-kinds=-iv -f ./tags $(python -c "import os, sys; print(\" \".join(\"{}\".format(d) for d in sys.path if os.path.isdir(d)))") .'
alias jupyterVenv='pip3 install ipykernel; python -m ipykernel install --name=venv'
alias tmuxbell="echo -e '\a'"
