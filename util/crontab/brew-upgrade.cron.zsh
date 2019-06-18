#!/usr/bin/env zsh
set -e # err_exit

brew_pre() {
  # GEGL fails to upgrade if coreutils is linked
  brew unlink coreutils
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
