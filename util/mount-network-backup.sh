#!/usr/bin/env bash

network_share="smb://jarjar.dev/ryan-osx-backups-share"
time_machine_bundle="/Volumes/ryan-osx-backups-share/time-machine.sparsebundle"
time_machine_dir="/Volumes/time-machine-backups"

# Mount the network share
osascript -e 'mount volume "'$network_share'"'

# Exit now if that failed
if [[ $? != 0 ]]; then
  ret_val=$!
  osascript -e 'display alert "Could not mount backup volume" message "Something went wrong trying to mount the network share." giving up after 5'
  exit $ret_val
fi

# Make sure the time machine bundle is where it's supposed to be
if [[ ! -d $time_machine_bundle ]]; then
  osascript -e 'display alert "Could not mount backup volume" message "The time machine bundle was not found." giving up after 5'
  exit 1
fi

# Mount the bundle itself
hdiutil mount $time_machine_bundle > /dev/null 2>&1

# Exit if that failed
if [[ $? != 0 ]]; then
  ret_val=$!
  osascript -e 'display alert "Could not mount backup volume" message "hdiutil failed to mount the time machine bundle." giving up after 5'
  exit $ret_val
fi

# One last check to make sure the backup volume is mounted
# where we expect it.
if [[ ! -d $time_machine_dir ]]; then
  osascript -e 'display alert "I am sorry. Something went wrong" message "The volume does not appear to have been mounted correctly." giving up after 8'
  exit 1
fi


osascript -e 'display notification "Successfully mounted your backup volume." with title "Backups should begin soon."'
exit 0;
