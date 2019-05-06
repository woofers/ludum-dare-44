#!/usr/bin/env bash

# Replace export path with current folder
BASE=$(basename $PWD)
sed -i "1cpath = '$BASE'"  src/export.lua

# Use p8 to add graphics
p8 install
luamin -f src/engine.lua > pico_modules/engine.lua
cp pico_modules/main.lua main.lua
p8 build
rm main.lua
