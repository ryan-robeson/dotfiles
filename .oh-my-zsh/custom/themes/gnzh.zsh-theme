# ZSH Theme - Preview: http://dl.dropbox.com/u/4109351/pics/gnzh-zsh-theme.png
# Based on bira theme

setopt prompt_subst

() {
  local PR_USER PR_PROMPT PR_HOST 

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
  else
    PR_HOST='%F{green}%M%f' # no SSH
  fi

  local return_code="%(?..%F{red}%? ↵%f)"

  local user_host="${PR_USER}%F{cyan}@${PR_HOST}"
  local current_dir="%B%F{blue}%~%f%b"
  local rvm_ruby=''
  if command -v rvm-prompt &> /dev/null; then
    rvm_ruby='%F{red}‹$(rvm-prompt i v g s)›%f'
  else
    if command -v rbenv 2>&1 >/dev/null; then
      rvm_ruby='%F{red}‹$(rbenv version | sed -e "s/ (set.*$//")›%f'
    fi
  fi
  # Check for boot2docker status
  #local boot2docker_running=''
  #boot2docker_running='$(which boot2docker &> /dev/null && [[ `boot2docker status` == "running" ]] && echo "🐳"  || echo "🌊")'

  local git_branch='$(git_prompt_info)'

  local check_keyboard_battery=false

  if [[ $check_keyboard_battery == true ]] && command -v keyboard_battery_prompt 2>&1 >/dev/null; then
    local kbc=$(keyboard_battery_color)
    local keyboard_battery="%F{$kbc}$(keyboard_battery_prompt)%f"
  else
    local keyboard_battery=''
  fi

  #PROMPT="╭─${user_host} ${current_dir} ${rvm_ruby} ${git_branch} ${boot2docker_running}
  #PROMPT="╭─${user_host} ${current_dir} ${rvm_ruby} ${git_branch} ${keyboard_battery}
  PROMPT="╭─${user_host} ${current_dir} ${rvm_ruby} ${git_branch}
╰─$PR_PROMPT "
  RPS1="${return_code}"

  ZSH_THEME_GIT_PROMPT_PREFIX="%F{yellow}‹"
  ZSH_THEME_GIT_PROMPT_SUFFIX="›%f"
}
