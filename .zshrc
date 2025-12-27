# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Change zsh custom dir so upgrades work
ZSH_CUSTOM=$HOME/src/dotfiles/.oh-my-zsh/custom

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="gnzh"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git ruby bundler macos docker osx-bluetooth-keyboard zsh-prompt-benchmark asdf)

DEFAULT_USER="ryan"

# Don't load oh-my-zsh if running under vscode
if [[ "$TERM_PROGRAM" != "vscode" ]]; then
  source $ZSH/oh-my-zsh.sh
else
  autoload -Uz compinit && compinit
fi

HISTSIZE=100000
SAVEHIST=$HISTSIZE
[ -f $HOME/bin/tmuxinator.zsh ] && source $HOME/bin/tmuxinator.zsh
[ -f $HOME/.api-keys ] && source $HOME/.api-keys
