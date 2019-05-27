#!/usr/bin/env ruby

# Add time deltas to STDIN
# Goal is to be similar to moreutils' `ts -i`.
# EXAMPLE:
#   # Change -xv to -v for more aggregated output
#   zsh -i -xv -c 'exit' 2>&1 | ./ts.rb > startup.log

# CLOCK_MONOTONIC is probably overkill, but it avoids problems
# with leap seconds and clock slew

start = nil

ARGF.each do |line|
  start ||= Process.clock_gettime(Process::CLOCK_MONOTONIC)
  finish = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  printf("%0.9f %s", finish - start, line)
  start = finish
end
