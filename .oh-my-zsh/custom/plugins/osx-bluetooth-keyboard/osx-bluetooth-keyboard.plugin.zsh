#!/usr/bin/env zsh

if [[ "$OSTYPE" = darwin* ]] ; then

  function keyboard_battery_percentage() {
    ioreg -r -p "IOService" -n AppleDeviceManagementHIDEventService | grep "BatteryPercent" | cut -d " " -f 9
  }

  function keyboard_battery_level() {
    local kbp=$(keyboard_battery_percentage)
    echo $kbp / 20 | bc
  }

  # Assumes PR_* have been defined as variables
  function keyboard_battery_color() {
    local level_color=("PR_RED" "PR_RED" "PR_YELLOW" "PR_GREEN" "PR_GREEN")
    echo -n '$'$level_color[$(keyboard_battery_level)]
  }

  function keyboard_battery_prompt() {
    local kbp=$(keyboard_battery_percentage)
    local prompt="<$kbp%% ⌨ >"
    echo -n "$prompt";
  }
fi


