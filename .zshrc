# Initalize Oh My Zsh
ZSH_DISABLE_COMPFIX=true # skip compaudit
DISABLE_MAGIC_FUNCTIONS=true # skip compinit
zstyle ':omz:lib:completion' skip yes # don't do compinit here, we'll do it later
export ZSH="$HOME/.oh-my-zsh"
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 13
DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="false"
# ZSH_THEME="robbyrussell"
export BAT_PAGER="cat"
plugins=(git zsh-syntax-highlighting zsh-autosuggestions zsh-bat) # you-should-use 
source $ZSH/oh-my-zsh.sh

# Initalize brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Startup text
figlet "davidterm" | lolcat

# Initalize NVM (lazy load)
export NVM_DIR="$HOME/.nvm"
nvm() {
  unfunction nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  nvm "$@"
}
node() { nvm use default >/dev/null; command node "$@"; }
npm()  { nvm use default >/dev/null; command npm "$@"; }
npx()  { nvm use default >/dev/null; command npx "$@"; }

# Terminal colors
autoload -U colors && colors
export CLICOLOR=1
export PS1="%{$fg[magenta]%}%n%{$reset_color%}»%{$fg[blue]%}%m %{$fg[green]%}%~%{$reset_color%}%  ⋈ "

# Change hostname
export HOST=dhei-mbp

# Custom aliases
alias skynet="ssh dheineman3@sky1.cc.gatech.edu"
alias skynet2="ssh dheineman3@sky2.cc.gatech.edu"
alias weather='curl "wttr.in/Seattle?format=3"'
alias ifconfig='curl ifconfig.me'

alias uvinit='uv venv --python 3.12 && source .venv/bin/activate'
alias uva='source .venv/bin/activate'
alias uvinstall='uv pip install -r requirements.txt'

# Upload to asciinema
au() {
    local out url
    out=$(asciinema upload "$@" 2>&1)
    url=$(printf '%s\n' "$out" | grep -Eo 'https://asciinema\.org/a/[A-Za-z0-9]+' | tail -n1)

    echo "$url"
    web "$url"
}

# disable pip (to encourage uv usage)
pip_path=$(which pip)
if [ -n "$pip_path" ] && [ -f "$pip_path" ]; then
  mv "$pip_path" "$(dirname "$pip_path")/pipforce"
fi
alias pip="uv pip" # Error: pip is disabled (use uv/uvinit/uva instead, its better). if you need to use it, call pipforce

o() {
    open -a "$*"
}
alias olist="ls /Applications /System/Applications /Applications/Utilities /System/Applications/Utilities ~/Applications 2>/dev/null"
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
atlas() {
    if [ -z "$*" ]; then
        open -a "/Applications/ChatGPT Atlas.app"
    else
        open -a "/Applications/ChatGPT Atlas.app" "https://chatgpt.com?prompt=$*"
    fi   
}
web() {
    if [ -z "$*" ]; then
        echo "Specify a website"
    else
        open -a "Google Chrome" "$*"
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
gdrive() {
    if [ -z "$*" ]; then
        open -a "Google Chrome" "https://drive.google.com/drive/u/1"
    else
        open -a "Google Chrome" "https://drive.google.com/drive/u/1/search?q=$*"
    fi
}
gdocs() {
    if [ -z "$*" ]; then
        open -a "Google Chrome" "https://docs.google.com/document/u/1"
    else
        open -a "Google Chrome" "https://docs.google.com/document/u/1/?q=$*"
    fi
}
gsheets() {
    if [ -z "$*" ]; then
        open -a "Google Chrome" "https://docs.google.com/spreadsheets/u/1"
    else
        open -a "Google Chrome" "https://docs.google.com/spreadsheets/u/1/?q=$*"
    fi
}
gslides() {
    if [ -z "$*" ]; then
        open -a "Google Chrome" "https://docs.google.com/presentation/u/1"
    else
        open -a "Google Chrome" "https://docs.google.com/presentation/u/1/?q=$*"
    fi
}
gcal() {
    open -a "Google Chrome" "https://calendar.google.com/calendar/u/1/r"
}
gmeet() {
    open -a "Google Chrome" "https://meet.google.com/landing?authuser=1"
}
gshare() {
    open -a "Google Chrome" "https://meet.google.com/landing?authuser=1&screenshare"
}
gjoin() {
    open -a "Google Chrome" "https://meet.google.com/landing?authuser=1&autojoin"
}
hf() {
    if [ -z "$*" ]; then
        open -a "Google Chrome" "https://huggingface.co/davidheineman"
    else
        open -a "Google Chrome" "https://huggingface.co/search/full-text?q=$*"
    fi
}
torch() {
    if [ -z "$*" ]; then
        open -a "Google Chrome" "https://pytorch.org/docs/stable"
    else
        open -a "Google Chrome" "https://pytorch.org/docs/stable/search.html?q=$*"
    fi
}
sweetgreen() {
    open -a "Google Chrome" "https://order.sweetgreen.com/11th-pine/535917-chicken-pesto-parm-s523/?reorderLineItemId=446626814"
}
evergreens() {
    open -a "Google Chrome" "https://order.evergreens.com/favorites"
}
condacreate() { # create conda env
    env_name=$1
    conda create -y -n "$env_name"
    conda install -y -n "$env_name" pip
    conda install -y -n "$env_name" python=3.10
    conda activate "$env_name"
}
ghview() { # open a repo on github.com
    gh repo view --web --branch $(git rev-parse --abbrev-ref HEAD)
}

rick() {
    curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash
}

# Manual override on Docker host to get beaker working
export DOCKER_HOST="unix:///Users/dhei/.docker/run/docker.sock"

# No HF tokenizer parallel
export TOKENIZERS_PARALLELISM=false

# move NLTK data
export NLTK_DATA=/opt/nltk_data

condainit() {
    ### Only initalize conda optionally
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
}

awscursor() {
    cursor --remote ssh-remote+ec2 /home/ec2-user
}

milton() {
  json=$(curl -s -H "Authorization: Bearer $MILTON_TOKEN" \
    "https://milton.apps.allenai.org/report?group=contact&start=$(date -v-1m +%Y-%m-%d)&end=$(date +%Y-%m-%d)")

  echo "Last month's cloud spend per user:"
  echo

  echo "$json" | jq -r '
    .groups[]
    | {contact: .contact, value: (.total.value | tonumber)}
    | select(.contact != null)
    | [.contact, (.value | tostring)]
    | @tsv
  ' | sort -k2 -nr | awk '
    BEGIN { printf "%-25s %15s\n", "USER", "SPEND ($)"; 
            printf "%-25s %15s\n", "------------------------", "-------------" }
    { printf "%-25s %15s\n", $1, $2 }
  '
}

ai2sock() {
    ssh -f -N -D 127.0.0.1:1080 ai2
    echo "Go to Wifi -> Details -> Proxies. Turn on SOCKS proxy. Set Server to '127.0.0.1' and Port to '1080'"
}

# if NOT inside VS Code or Cursor
if [[ -z "$VSCODE_PID" && "$TERM_PROGRAM" != "vscode" && "$TERM_PROGRAM" != "cursor" ]]; then
  uva
fi

fpath+=~/.zfunc
fpath=(/Users/dhei/.docker/completions $fpath) # Docker desktop CLI completions

### Autocomplete (rebuild cache one a day)
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
###

### Back-up the main ~/.zshrc -> ~/.zshrc-bak every 24 hours
if [[ -n ~/.zshrc-bak(#qN.mh+24) ]] || [[ ! -f ~/.zshrc-bak ]]; then
  cp ~/.zshrc ~/.zshrc-bak
fi

zstyle ':completion:*' menu selectexport PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"

export PATH="/usr/local/bin:$PATH"