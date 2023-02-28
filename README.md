## Set hostname
```zsh
sudo scutil --set HostName macbookpro
```

## Install Homebrew and packages
```zsh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew bundle --file=~/dotfiles/Brewfile
```

## Remap Caps Lock to F18 (https://hidutil-generator.netlify.app)
```zsh
hidutil property --set '{
    "UserKeyMapping": [{
        "HIDKeyboardModifierMappingSrc": 0x700000039,
        "HIDKeyboardModifierMappingDst": 0x70000006D
    }]
}'
ln -sf ~/dotfiles/hammerspoon/KeyRemapping.plist \
       ~/Library/LaunchAgents/com.local.KeyRemapping.plist
```

## Change default location of Hammerspoon config
defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"

## Symlink config files
```zsh
mkdir -p ~/.config/git
ln -s ~/dotfiles/hammerspoon ~/.config/hammerspoon
ln -s ~/dotfiles/neovim ~/.config/nvim
ln -s ~/dotfiles/wezterm ~/.config/wezterm
ln -s ~/dotfiles/misc/gitconfig ~/.config/git/config
ln -s ~/dotfiles/misc/zprofile ~/.zprofile
```

## Update Brewfile
```zsh
brew bundle dump ~/dotfiles/Brewfile --force
```

