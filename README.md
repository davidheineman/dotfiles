My MacOS Setup

```sh
# clone and install
git clone https://github.com/davidheineman/dotfiles.git
chmod +x macos_setup.sh
./macos_setup.sh

# add aliases to ~/.zshrc
echo -e "\n# initialize aliases" >> ~/.zshrc
echo -e "source $(pwd)/.zshrc" >> ~/.zshrc
```

```sh
# alternatively, install directly from repo
sudo curl -s https://raw.githubusercontent.com/davidheineman/dotfiles/main/macos_setup.sh | sh
```
