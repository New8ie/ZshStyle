
![lazyvim screenshot][screenshot]

Requirements

* Neovim >= 0.9.0 (needs to be built with LuaJIT)
* Git >= 2.19.0 (for partial clones support)
* a Nerd Font(v3.0 or greater) (optional, but needed to display some icons)
* lazygit (optional)
* a C compiler for nvim-treesitter. See here
* curl for blink.cmp (completion engine)
* for fzf-lua (optional)
    fzf: fzf (v0.25.1 or greater)
    live grep: ripgrep
    find files: fd
* a terminal that support true color and undercurl:
    kitty (Linux & Macos)
    wezterm (Linux, Macos & Windows)
    alacritty (Linux, Macos & Windows)
    iterm2 (Macos)

# Install Lazyvim

Pre-built archives
The Releases page provides pre-built binaries for Linux systems.

Debian or Ubuntu
```sh
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
```
Then add PATH this to your shell config (~/.bashrc, ~/.zshrc, ...):

```sh
export PATH="$PATH:/opt/nvim-linux64/bin"
```
Optional:
For sudo users add this path to /etc/sudoers in "secure_path:"

Check version neovim with this command " nvim -v "
```sh
Output:
NVIM v0.10.2
Build type: Release
LuaJIT 2.1.1732813678
Run "nvim -V1 -v" for more info
```

Backup neovim
```sh
# required
mv ~/.config/nvim{,.bak}

# optional but recommended
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}
```

Clone the repository
```sh
git clone https://github.com/LazyVim/starter ~/.config/nvim
```
Remove the .git folder, so you can add it to your own repo later
```sh
rm -rf ~/.config/nvim/.git
```

Done!

For more guide check the [lazyvim web][web] website

[screenshot]: https://github.com/New8ie/ZshStyle/blob/main/screenshot/lazyvim.png
[web]: https://www.lazyvim.org/






















