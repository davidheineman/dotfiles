My MacOS Setup

```sh
# clone and install
git clone https://github.com/davidheineman/dotfiles.git
chmod +x macos_setup.sh
./macos_setup.sh

chmod .zshrc
cp .zshrc ~/.zshrc
source ~/.zshrc
```

```sh
# install directly from repo
curl -o https://raw.githubusercontent.com/davidheineman/dotfiles/main/macos_setup.sh | sh
```

TODO:
- Find some way to link ~/.zshrc to the .zshrc here (symlink?)
- Create prompts for secrets/logins (HF, git, openai)