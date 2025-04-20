My MacOS Setup

```sh
# clone and install
git clone https://github.com/davidheineman/dotfiles.git
chmod +x macos_setup.sh
./macos_setup.sh

# add aliases to ~/.zshrc
chmod +x $(pwd)/.zshrc # make it executable
grep -qxF "source $(pwd)/.zshrc" ~/.zshrc || echo "\n\n# Initialize personal aliases\nsource $(pwd)/.zshrc" >> ~/.zshrc # add to terminal init
```

```sh
# alternatively, install directly from repo
sudo curl -s https://raw.githubusercontent.com/davidheineman/dotfiles/main/macos_setup.sh | sh
```
