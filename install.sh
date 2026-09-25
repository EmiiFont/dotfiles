#!/bin/bash

# Install Homebrew if not already installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed."
fi

# Update Homebrew
export PATH=$PATH:/opt/homebrew/bin

echo "Updating Homebrew..."
brew update

# Install everything from the Brewfile (formulae + casks)
echo "Installing formulae and casks from Brewfile..."
brew bundle --file="$(dirname "$0")/Brewfile"

echo "Installating some dev tools!"

pipx install posting
nvm install 22

echo "source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
