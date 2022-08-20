#!/usr/bin/env bash

# Dotfiles of Jaewoong Cheon <cheonjaewoong@gmail.com>

if [ "$(uname -s)" != "Darwin" ]; then
    echo "Run script on macOS"
    exit 1
fi

cd "$HOME" || exit 1

# Get emails
echo "Enter personal email (e.g. example@sample.com): "
read EMAIL_PERSONAL
echo "Enter company email (e.g. example@company.org): "
read EMAIL_COMPANY

function is_not_exist() {
    if [ -z "$(which "$1")" ]; then
        return 0
    else
        return 1
    fi
}

# Install Homebrew
if is_not_exist "brew"; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install tools
TOOLS=(
    vim
    tree
    git
    gh # GitHub command line tool
    ripgrep # Command line search tool
    fzf # Command line fuzzy finder
    openssh
    hugo # Static site generator for my blog
)

for TOOL in "${TOOLS[@]}"; do
    echo "Install $TOOL"
    brew install "$TOOL"
done

# Install programming languages and tools
LANGS=(
    kotlin
    gradle
    maven
    go
    python
    node
    ruby
    cmake
)
LANGS_CASK=(
    temurin # Eclipse Temurin JDK
)

for LANG in "${LANGS[@]}"; do
    echo "Install $LANG"
    brew install "$LANG"
done

for LANG_CASK in "${LANGS_CASK[@]}"; do
    echo "Install $LANG_CASK"
    brew install --cask "$LANG_CASK"
done

# Install applications
APPS=(
    google-chrome
    alacritty # GPU-accelerated terminal emulator
    rectangle # macOS window moving & resizing
    tunnelblick # Free and open-source OpenVPN client
    discord
    slack
    figma
    appcleaner # macOS application uninstaller & cleanup tool
    visual-studio-code
    jetbrains-toolbox
    android-studio
    intellij-idea # Intellij IDEA Ultimate Edition
    goland
    clion
    pycharm # Pycharm Professional Edition
    webstorm
    datagrip # Jetbrains' database IDE
)

for APP in "${APPS[@]}"; do
    echo "Install $APP"
    brew install --cask "$APP"
done

# Install fish shell
if is_not_exist; then
    echo "Install fish shell"
    brew install fish
fi

# Change default shell to fish
echo "$(which fish)" | sudo tee -a /etc/shells
chsh -s "$(which fish)"

# Install oh-my-fish
curl -L https://get.oh-my.fish | fish

# Set fish theme to default
omf theme default
fish

# Git settings
git config --global user.name "Jaewoong Cheon"
git config --global user.email "$EMAIL_PERSONAL"

# SSH settings
cd "$HOME" || exit 1
mkdir -p .ssh
cd .ssh || exit 1

ssh-keygen -t rsa -b 4096 -C "$EMAIL_PERSONAL" -f "id_rsa_github_personal"
ssh-keygen -t rsa -b 4096 -C "$EMAIL_COMPANY" -f "id_rsa_github_company"
echo "SSH keys are generated in $HOME/.ssh/"
echo "Add SSH keys to GitHub"
open "https://github.com/settings/keys" -a "Google Chrome" --args --make-default-browser
