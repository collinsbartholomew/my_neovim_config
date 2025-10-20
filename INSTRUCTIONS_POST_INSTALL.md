# Manual Post-Install Steps

The following system packages were not detected and must be installed for full Neovim IDE functionality:

- neovim-git (AUR)
- git
- ripgrep
- fd
- nodejs
- npm
- python3
- python-pynvim
- lua-language-server
- ttf-nerd-fonts-symbols
- ttf-fira-code
- xclip
- paru or pikaur (AUR helper)

## Install with pacman (official packages)
```
sudo pacman -S --noconfirm git ripgrep fd nodejs npm python-pynvim lua-language-server ttf-nerd-fonts-symbols ttf-fira-code xclip
```

## Install neovim-git (AUR)
If not available in official repos, use paru or pikaur:
```
paru -S --noconfirm neovim-git
```

## Optional GUI frontends
```
sudo pacman -S --noconfirm neovide neovim-qt
```

After installing these packages, re-run the setup agent to complete plugin installation and verification.

