#!/usr/bin/env zsh
set -e # err_exit

brew_pre() {
  # GEGL fails to upgrade if coreutils is linked
  brew unlink coreutils

  # Rebase our changes to homebrew-core on the current master
  cd $(brew --prefix)/Homebrew/Library/Taps/homebrew/homebrew-core
  if [[ `git branch --show-current` == 'custom' ]]; then
    git rebase master
  fi
}

brew_post() {
  # Don't need GEGL linked, but coreutils is nice
  brew unlink gegl
  brew link coreutils

  # Make sure ffmpeg still functions
  if ! ffmpeg -version >/dev/null 2>&1; then
    # This may fail
    set +e
    brew reinstall ffmpeg
    set -e
  fi
}

brew update

brew_pre

brew upgrade --display-times

brew_post

brew cask upgrade
