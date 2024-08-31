My MacOS Setup

```sh
chmod +x macos_setup.sh
./macos_setup.sh

chmod .zshrc
cp .zshrc ~/.zshrc
source ~/.zshrc
```

TODO:
- Add a command to install with 'curl -o https://github.com/davidheineman/dotfiles | sh'
- Find some way to link ~/.zshrc to the .zshrc here (symlink?)
- Create prompts for secrets/logins (HF, git, openai)