#!/usr/bin/env bash

# Build game
./build.sh

# Export for web
timeout 2s pico8 -x alien-expansion.p8

# Move to dist folder
mkdir dist >> /dev/null
mv index.js index.html dist
