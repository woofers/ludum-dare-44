#!/usr/bin/env bash

# Build game
./build.sh

# Export for web
pico8 -x alien-expansion.p8

# Move to dist folder
mkdir dist >> /dev/null
mv index.js index.html dist
