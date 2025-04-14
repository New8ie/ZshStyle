This Guide To Fresh Install Your New Laptop or Desktop 
===
<!--rehype:style=font-size: 38px; border-bottom: 0; display: flex; min-height: 260px; align-items: center; justify-content: center;-->

![dotfiles screenshot][screenshot]


# Install ZSH
```bash
## MacOS
brew install Zsh
## Debian / Ubuntu
sudo apt-get install zsh
```
To set zsh as your default shell, execute the following assuming a default install of Homebrew
Recent macOS versions:

For m1/m2
```bash
chsh -s $(which zsh)
```
For intel64
```bash
chsh -s /usr/bin/zsh
```
If you get an error for non-stadard shell you can try running first
```bash
sudo sh -c "echo $(which zsh) >> /etc/shells"
```
to other platform check this link [zsh link][zsh]

# Install CLI tools

* Eza
```bash
## Ubuntu / Debian
sudo apt update
sudo apt install -y gpg
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza
## MacOS
brew install eza
```
![eza screenshot][eza]
* Bat
```bash
## Ubuntu / Debian
sudo apt install bat
mkdir -p ~/.local/bin
ln -s /usr/bin/batcat ~/.local/bin/bat
## MacOS
brew install bat
```
![bat screenshot][bat]

* Nanorc
```bash
curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh
```
* Grc
```bash
## Ubuntu / Debian
 sudo apt install grc 
## MacOS
brew install grc
```
![grc screenshot][grc]
* Fzf
```bash
## Ubuntu / Debian
sudo apt install fzf
## MacOS
brew install fzf
```

# Oh-My-Zsh & Plugins 

* Install oh-my-zsh
```bash
## Curl
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
## Wget
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
```
* Install Plugins 
```bash
# Zsh-Syntax-Highlighting 
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}"/plugins/zsh-syntax-highlighting
# Zsh-AutoSuggestion
git clone https://github.com/zsh-users/zsh-autosuggestions.git "${ZSH_CUSTOM}"/plugins/zsh-autosuggestions
# You-should-use
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git "${ZSH_CUSTOM}"/plugins/zsh-you-should-use
# Zsh-Bat 
git clone https://github.com/fdellwing/zsh-bat.git "${ZSH_CUSTOM}"/plugins/zsh-bat
# Zsh-Eza
git clone https://github.com/z-shell/zsh-eza.git "${ZSH_CUSTOM}"/plugins/zsh-eza

## Copy & replace .zshrc .zprofile from repo
wget -qO- https://raw.githubusercontent.com/New8ie/ZshStyle/refs/heads/main/zsh/.zshrc
wget -qO- https://raw.githubusercontent.com/New8ie/ZshStyle/refs/heads/main/zsh/.zprofile

# Install powerlevel10k and configure

```bash
## Clone Repo
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
## Copy .p10k.zsh from repo 
wget -qO-https://raw.githubusercontent.com/New8ie/ZshStyle/refs/heads/main/zsh/.p10k.zsh
```


Here is a bash script to auto install and download the required files.
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/New8ie/ZshStyle/refs/heads/main/script/zsh-script-v2.sh)"
```




# For Root

Create Symlink
```sh
sudo ln -s $HOME/.oh-my-zsh /root/.oh-my-zsh
sudo ln -s $HOME/.zshrc /root/.zshrc
sudo ln -s $HOME/.p10k.zsh /root/.p10k.zsh
sudo ln -s $HOME/.local /root/.local
```
For config dotfiles Lazyvim,lazygit,nanorc and etc..
```sh
sudo ln -s $HOME/.config /root/.config
``` 

Add command in your zshrc files
```sh 
ZSH_DISABLE_COMPFIX=true
```


[grc]: https://github.com/New8ie/ZshStyle/blob/main/screenshot/grc.png
[screenshot]: https://github.com/New8ie/ZshStyle/blob/main/screenshot/ohmyzsh.png
[bat]: https://github.com/New8ie/ZshStyle/blob/main/screenshot/bat.png
[eza]: https://github.com/New8ie/ZshStyle/blob/main/screenshot/eza.png
[zsh]: https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH
