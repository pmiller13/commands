#!/usr/bin/env bash

set -ex

BREW=/opt/homebrew/bin/brew
PIP=$(which pip)

# don't write DS_Store on network drives
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# default list view in finder
defaults write com.apple.Finder FXPreferredViewStyle Nlsv

# turn on dock hiding
defaults write com.apple.dock autohide -bool true

# open new windows in my home dir
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# show the ~/Library folder
chflags nohidden ~/Library

# enable text selection in QuickLook
defaults write com.apple.finder QLEnableTextSelection -bool true

# use the Pro theme by default in terminal
defaults write com.apple.Terminal "Default Window Settings" -string "Pro"
defaults write com.apple.Terminal "Startup Window Settings" -string "Pro"
defaults import com.apple.Terminal "$HOME/Library/Preferences/com.apple.Terminal.plist"

# expand save and print panels by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# disable press-and-hold for keys in favor of key repeat
defaults write -g ApplePressAndHoldEnabled -bool false

# set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# show Status bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true

# disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Disable dashboard
defaults write com.apple.dashboard mcx-disabled -boolean YES

# Reduce motion
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

# Instance switching between spaces
defaults write com.apple.dock workspaces-edge-delay -float 0.1

# Disable dock launch animation
defaults write com.apple.dock launchanim -bool false

# Dumping ground of disabling animations in Ventura (pulled from Reddit)
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
defaults write -g NSScrollAnimationEnabled -bool false
defaults write -g NSWindowResizeTime -float 0.001
defaults write -g QLPanelAnimationDuration -float 0
defaults write -g NSScrollViewRubberbanding -bool false
defaults write -g NSDocumentRevisionsWindowTransformAnimation -bool false
defaults write -g NSToolbarFullScreenAnimationDuration -float 0
defaults write -g NSBrowserColumnAnimationSpeedMultiplier -float 0
defaults write com.apple.dock autohide-time-modifier -float 0
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock expose-animation-duration -float 0
defaults write com.apple.dock springboard-show-duration -float 0
defaults write com.apple.dock springboard-hide-duration -float 0
defaults write com.apple.dock springboard-page-duration -float 0
defaults write com.apple.finder DisableAllAnimations -bool true
defaults write com.apple.Mail DisableSendAnimations -bool true
defaults write com.apple.Mail DisableReplyAnimations -bool true

if [ ! -x $BREW ]; then
  echo 'installing homebrew'
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  (
    echo
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"'
  ) >>/Users/p/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo 'updating homebrew'
$BREW update

$BREW doctor -d
if [ $? -ne 0 ]; then
  echo 'brew bad?'
  exit 1
fi

# Do the brew
brew_plugins=(
  ag
  asdf
  cmake
  colordiff
  curl
  direnv
  fzf
  geoip
  go
  gofumpt
  htop-osx
  jq
  kubectl
  moreutils
  multipass
  node
  python
  rbenv
  readline
  shellcheck
  task
  thefuck
  tree
  v8
  vim
  watchman
  wget
  xz
  yarn
  yq
  zsh-autosuggestions
  zsh-syntax-highlighting
)

for brew_thing in "${brew_plugins[@]}"; do
  $BREW install $brew_thing
done

# if [ ! "$(which ipython)" ]; then
#   echo 'installing ipython'
#   $PIP install ipython
# fi

# if [ ! "$(which aws)" ]; then
#   echo 'installing awscli'
#   $PIP install awscli
#   complete -C aws_completer aws
# fi

# if [ ! "$(which gcloud)" ]; then
#   echo 'installing gcloud'
#   $BREW install --cask google-cloud-sdk
# fi

$PIP install --user neovim flake8 pylint pep8

if [ ! -f "$HOME/.zshrc" ]; then
  cp _.zshrc "$HOME/.zshrc"
fi
