#!/bin/bash

# Install Homebrew if not already installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed."
fi

# Update Homebrew
echo "Updating Homebrew..."
brew update

# List of Homebrew Formulae to install
formulae=(
    auth0
    cffi
    fd
    giflib
    icu4c@76
    libgit2@1.7
    libvterm
    libxrender
    lzo
    oniguruma
    pycparser
    readline
    xorgproto
    autoconf
    flyctl
    fontconfig
    glib
    jpeg-turbo
    libpng
    libx11
    little-cms2
    m4
    openjdk
    pyenv
    ripgrep
    xz
    bat
    cryptography
    go
    jq
    libssh2
    libxau
    lpeg
    mongodb-database-tools
    openssl@3
    python-packaging
    sqlite
    zoxide
    ca-certificates
    docker-compose
    freetype
    graphite2
    lazydocker
    libtiff
    libxcb
    luajit
    mpdecimal
    pcre2
    python@3.11
    terraform
    zstd
    cairo
    exercism
    fzf
    harfbuzz
    lazygit
    libunistring
    libxdmcp
    luv
    msgpack
    pixman
    tree-sitter
    certifi
    eza
    gettext
    httpie
    libgit2
    libuv
    libxext
    lz4
    neovim
    pkgconf
    python@3.13
    unibilium
)

# List of Homebrew Casks to install
casks=(
    amethyst
    ghostty
    git-credential-manager
    ngrok
)

# Install Homebrew Formulae
echo "Installing Homebrew Formulae..."
brew install "${formulae[@]}"

# Install Homebrew Casks
echo "Installing Homebrew Casks..."
brew install --cask "${casks[@]}"

echo "Installation complete!"
