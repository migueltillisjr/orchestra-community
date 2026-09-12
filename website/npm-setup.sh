#!/bin/bash

# Install wrangler globally using npm
npm install -g wrangler

# Get the npm global prefix
npm_prefix=$(npm config get prefix)

# Add the npm global binary directory to the PATH
echo "export PATH=\$PATH:$npm_prefix/bin" >> ~/.bashrc

# Reload the shell configuration
source ~/.bashrc

# Verify the installation
wrangler --version