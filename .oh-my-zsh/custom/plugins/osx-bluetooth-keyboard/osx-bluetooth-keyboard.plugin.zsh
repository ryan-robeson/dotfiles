#!/usr/bin/env zsh

if [[ "$OSTYPE" = darwin* ]] ; then

  function keyboard_battery_percentage() {
    ioreg -r -p "IOService" -n AppleDeviceManagementHIDEventService | grep "BatteryPercent" | cut -d " " -f 9
  }

  function keyboard_battery_level() {
    local kbp=$(keyboard_battery_percentage)

    # Assume full charge when not connected.
    # Probably not ideal.
    if [ -z "$kbp" ]; then
      kbp=100
    fi
    echo $kbp / 20 | bc
  }

  function keyboard_battery_color() {
    local level_color=("red" "red" "yellow" "green" "green")
    echo -n $level_color[$(keyboard_battery_level)]
  }

  function keyboard_battery_prompt() {
    local kbp=$(keyboard_battery_percentage)
    local prompt="$kbp%% ⌨ "
    echo -n "$prompt";
  }
fi
