#!/usr/bin/env zsh

# Simple script for benchmarking
# Useful for optimizing zsh themes and plugins
local result min max

zmodload -ui zsh/zprof
zmodload zsh/zprof

min=1
max=1000

function a() {
}

function b() {
}

for f in "a" "b"; do
  for ((i=min; i<=max; i++)); do
    eval $f
  done
done

zprof

zmodload -u zsh/zprof
