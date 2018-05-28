# ZSH Theme - Preview: http://dl.dropbox.com/u/4109351/pics/gnzh-zsh-theme.png
# Based on bira theme

# load some modules
autoload -U colors zsh/terminfo # Used in the colour alias below
colors
setopt prompt_subst

# make some aliases for the colours: (coud use normal escap.seq's too)
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
  eval PR_$color='%{$fg[${(L)color}]%}'
done
eval PR_NO_COLOR="%{$terminfo[sgr0]%}"
eval PR_BOLD="%{$terminfo[bold]%}"

# Check the UID
if [[ $UID -ge 500 ]]; then # normal user
  eval PR_USER='${PR_GREEN}%n${PR_NO_COLOR}'
  eval PR_USER_OP='${PR_GREEN}%#${PR_NO_COLOR}'
  local PR_PROMPT='$PR_NO_COLOR➤ $PR_NO_COLOR'
elif [[ $UID -eq 0 ]]; then # root
  eval PR_USER='${PR_RED}%n${PR_NO_COLOR}'
  eval PR_USER_OP='${PR_RED}%#${PR_NO_COLOR}'
  local PR_PROMPT='$PR_RED➤ $PR_NO_COLOR'
fi

# Check if we are on SSH or not
if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then 
  eval PR_HOST='${PR_YELLOW}%M${PR_NO_COLOR}' #SSH
else
  eval PR_HOST='${PR_GREEN}%M${PR_NO_COLOR}' # no SSH
fi

local return_code="%(?..%{$PR_RED%}%? ↵%{$PR_NO_COLOR%})"

local user_host='${PR_USER}${PR_CYAN}@${PR_HOST}'
local current_dir='%{$PR_BOLD$PR_BLUE%}%~%{$PR_NO_COLOR%}'
local rvm_ruby=''
if command -v rvm-prompt &> /dev/null; then
  rvm_ruby='%{$PR_RED%}‹$(rvm-prompt i v g s)›%{$PR_NO_COLOR%}'
else
  if command -v rbenv 2>&1 >/dev/null; then
    rvm_ruby='%{$PR_RED%}‹$(rbenv version | sed -e "s/ (set.*$//")›%{$PR_NO_COLOR%}'
  fi
fi
# Check for boot2docker status
#local boot2docker_running=''
#boot2docker_running='$(which boot2docker &> /dev/null && [[ `boot2docker status` == "running" ]] && echo "🐳"  || echo "🌊")'

local git_branch='$(git_prompt_info)%{$PR_NO_COLOR%}'

if command -v keyboard_battery_prompt 2>&1 >/dev/null; then
  #eval local kbc=$(keyboard_battery_color)
  eval local kbc=$(keyboard_battery_color)
  local keyboard_battery='$kbc$(keyboard_battery_prompt)%{$PR_NO_COLOR%}'
else
  local keyboard_battery=''
fi

#PROMPT="${user_host} ${current_dir} ${rvm_ruby} ${git_branch}$PR_PROMPT "
#PROMPT="╭─${user_host} ${current_dir} ${rvm_ruby} ${git_branch} ${boot2docker_running}
#PROMPT="╭─${user_host} ${current_dir} ${rvm_ruby} ${git_branch}
PROMPT="╭─${user_host} ${current_dir} ${rvm_ruby} ${git_branch} ${keyboard_battery}
╰─$PR_PROMPT "
RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$PR_YELLOW%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="›%{$PR_NO_COLOR%}"
