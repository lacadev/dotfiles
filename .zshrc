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

# Set up pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi


# iTerm2 zsh integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Have a look at https://stackoverflow.com/questions/12018783/how-to-set-iterm2-tab-title-to-that-of-a-running-tmux-session-name
# for more info on terminal tab names
DISABLE_AUTO_TITLE="true"

# Go executables
export PATH="$HOME/go/bin:$PATH"

# ALIASES
alias wisdom="fortune | cowsay | lolcat"
alias vim='nvim'
alias tmuxbell="echo -e '\a'"

# Tmux will use this to determine which shell to use
export SHELL="$(which zsh)"

export PATH="$HOME/.poetry/bin:$PATH"
# Date on the right of the prompt
# RPROMPT="%{$fg[blue]%}[%@]"
