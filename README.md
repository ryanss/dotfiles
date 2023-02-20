## Set hostname
```zsh
sudo scutil --set HostName macbookpro
```

## Install Homebrew and packages
```zsh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew bundle --file=~/dotfiles/Brewfile
```

## Symlink config files
```zsh
mkdir -p ~/.config/git
ln -s ~/dotfiles/misc/gitconfig ~/.config/git/config
ln -s ~/dotfiles/misc/zprofile ~/.zprofile
ln -s ~/dotfiles/neovim ~/.config/nvim
ln -s ~/dotfiles/wezterm ~/.config/wezterm
```

## Update Brewfile
```zsh
brew bundle dump ~/dotfiles/Brewfile --force
```

