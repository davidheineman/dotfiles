# Initalize Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 13
DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="false" # true
export BAT_PAGER="cat"
plugins=(git zsh-syntax-highlighting zsh-autosuggestions you-should-use zsh-bat)
source $ZSH/oh-my-zsh.sh

# Initalize brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Startup text
figlet "davidterm" | lolcat
echo "ai2 | skynet | chat | acl | chrome | scholar | weather | ifconfig | spotify | slack | notion | texts | photos | maps | code" | cut -c -$(tput cols) | lolcat

# Initalize NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Initalize Conda
__conda_setup="$('/Users/dhei/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/dhei/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/dhei/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/dhei/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
conda activate base

# Terminal colors
autoload -U colors && colors
export CLICOLOR=1
export PS1="%{$fg[magenta]%}%n%{$reset_color%}»%{$fg[blue]%}%m %{$fg[green]%}%~%{$reset_color%}%  ⋈ "

# Change hostname
export HOST=dhei-mbp

# Custom aliases
alias skynet="ssh dheineman3@sky1.cc.gatech.edu"
alias skynet2="ssh dheineman3@sky2.cc.gatech.edu"
alias ai2="ssh ai2test"
alias weather='curl "wttr.in/Seattle?format=3"'
alias ifconfig='curl ifconfig.me'

alias spotify='open -a "Spotify"'
alias slack='open -a "Slack"'
alias notion='open -a "Notion"'
alias texts='open -a "Messages"'
chrome() {
    if [ -z "$*" ]; then
        open -a "Google Chrome"
    else
        open -a "Google Chrome" "https://www.google.com/search?q=$*"
    fi
}
photos() {
    if [ -z "$*" ]; then
        open -a "Google Chrome" "https://photos.google.com"
    else
        open -a "Google Chrome" "https://photos.google.com/search/$*"
    fi
}
maps() {
    if [ -z "$*" ]; then
        open -a "Google Chrome" "https://www.google.com/maps"
    else
        open -a "Google Chrome" "https://www.google.com/maps/search/$*"
    fi
}
scholar() {
    if [ -z "$*" ]; then
        open -a "Google Chrome" "https://scholar.google.com"
    else
        open -a "Google Chrome" "https://scholar.google.com/scholar?hl=en&q=$*" # &btnI=
    fi
}

# [Add secrets here!]
