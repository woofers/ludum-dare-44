#!/usr/bin/env bash

# Use p8 to add graphics
p8 install
luamin -f src/engine.lua > pico_modules/engine.lua
cp pico_modules/main.lua main.lua
p8 build
