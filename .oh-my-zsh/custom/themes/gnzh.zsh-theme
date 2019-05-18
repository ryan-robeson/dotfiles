# ZSH Theme - Preview: http://dl.dropbox.com/u/4109351/pics/gnzh-zsh-theme.png
# Based on bira theme

setopt prompt_subst

# Custom cache - Probably overkill
typeset -A _OMZ_CACHE _OMZ_CACHE_EXPIRATIONS

() {
  local PR_USER PR_PROMPT PR_HOST IS_SSH

  # Custom rbenv_prompt_info
  if [[ "function" = ${(M)$( whence -w rbenv ):#function} ]]; then
    # rbenv is already loaded

    function rbenv_prompt_info() {
      echo "${ZSH_THEME_RUBY_PROMPT_PREFIX}$(rbenv version-name)${ZSH_THEME_RUBY_PROMPT_SUFFIX}"
    }
  fi

  # $1 - key
  function _OMZ_CACHE_GET() {
    cache_invalid=false

    if [[ -n $1 ]]; then
      expiration=$_OMZ_CACHE_EXPIRATIONS["$1"]
      if [[ -n $expiration ]]; then
        # an expiration time is set
        if [[ $(date +%s) -gt $expiration ]]; then
          cache_invalid=true
        fi
      fi

      value=$_OMZ_CACHE["$1"]
      if [[ ! -n $value ]]; then
        cache_invalid=true
      fi

      if [[ $cache_invalid = true ]]; then
        echo ''
        return 1
      fi

      echo $value
    fi
  }

  # $1 - key
  # $2 - value
  # $3 - expires in... (seconds)
  function _OMZ_CACHE_SET() {
    _OMZ_CACHE["$1"]=$2
    if [[ -n $3 ]]; then
      _OMZ_CACHE_EXPIRATIONS["$1"]=$(( $(date +%s) + $3 ))
    else
      _OMZ_CACHE_EXPIRATIONS["$1"]=
    fi
  }

  # Check the UID
  if [[ $UID -ne 0 ]]; then # normal user
    PR_USER='%F{green}%n%f'
    PR_PROMPT='%f➤ %f'
  else # root
    PR_USER='%F{red}%n%f'
    PR_PROMPT='%F{red}➤ %f'
  fi

  # Check if we are on SSH or not
  if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then
    PR_HOST='%F{yellow}%M%f' #SSH
    IS_SSH=true
  else
    PR_HOST='%F{green}%m%f' # no SSH
    IS_SSH=false
  fi

  local return_code="%(?..%F{red}%? ↵%f)"

  # Only show the user and host if not logged in as $DEFAULT_USER
  # or on SSH
  local user_host=''
  if [[ "$USER" != "$DEFAULT_USER" || $IS_SSH == true ]]; then
    user_host="${PR_USER}%F{cyan}@%-100(l|%20>..>${PR_HOST}|%7>..>${PR_HOST})"
  fi
  local current_dir="%B%F{blue}%-100(l.%75<:<%~.%-80(l.%50<:<%~.%20<:<%~))%f%b"
  local git_branch='$(git_prompt_info)'

  # Check for boot2docker status
  #local boot2docker_running=''
  #boot2docker_running='$(which boot2docker &> /dev/null && [[ `boot2docker status` == "running" ]] && echo "🐳"  || echo "🌊")'

  if [[ $IS_SSH != true ]] && command -v keyboard_battery_prompt 2>&1 >/dev/null; then
    function _keyboard_battery() {
      local keyboard_level=$(_OMZ_CACHE_GET "keyboard_level")
      if [[ ! -n $keyboard_level ]]; then
        keyboard_level=$(keyboard_battery_level)
        _OMZ_CACHE_SET "keyboard_level" $keyboard_level $(( 30 * 60 ))
      fi
      # Only show the keyboard prompt when the battery is low
      if [[ $keyboard_level -le 1 ]]; then
        local keyboard_prompt=$(_OMZ_CACHE_GET "keyboard_prompt")
        if [[ ! -n $keyboard_prompt ]]; then
          keyboard_prompt=" %F{$(keyboard_battery_color)}$(keyboard_battery_prompt)%f"
          _OMZ_CACHE_SET "keyboard_prompt" $keyboard_prompt $(( 30 * 60 ))
        fi
      fi
    }
    local keyboard_battery='$(_OMZ_CACHE_GET "keyboard_prompt")'
  else
    local keyboard_battery=''
  fi

  periodic_functions=($periodic_functions _keyboard_battery)
  : ${PERIOD:=120}

  #PROMPT="╭─${user_host} ${current_dir} ${rvm_ruby} ${git_branch} ${boot2docker_running}
  #PROMPT="╭─${user_host} ${current_dir} ${rvm_ruby} ${git_branch}
  #PROMPT="╭─${user_host} ${current_dir} \$(rbenv_prompt_info) ${git_branch} ${keyboard_battery}
  PROMPT="╭─${user_host} ${current_dir}\$(rbenv_prompt_info)${git_branch}%-30(l.${keyboard_battery}.)
╰─$PR_PROMPT "
  RPS1="%@ ${return_code}"

  ZSH_THEME_GIT_PROMPT_PREFIX=" %F{yellow}‹"
  ZSH_THEME_GIT_PROMPT_SUFFIX="›%f"
  ZSH_THEME_RUBY_PROMPT_PREFIX=" %F{red}‹"
  ZSH_THEME_RUBY_PROMPT_SUFFIX="›%f"
}
