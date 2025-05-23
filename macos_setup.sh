# Save screenshots to Downloads
defaults write com.apple.screencapture location "${HOME}/Downloads"

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Finder settings
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0

# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Do not create .DS_Store files...
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true # ... on remote disks
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true # ... on USB stores
defaults write com.apple.desktopservices DSDontWriteLocalStores -bool true # ... anywhere locally

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Show the ~/Library folder
chflags nohidden ~/Library

# Restart SystemUIServer
killall SystemUIServer

# Get rid of the dock
# defaults write com.apple.dock tilesize -int 10
defaults write com.apple.dock autohide-time-modifier -float 0
# killall Dock

# Disable chrome in spotlight search
defaults write com.apple.safari UniversalSearchEnabled -bool false

# Disable update notifications for MacOS
defaults write com.apple.SoftwareUpdate MajorOSUserNotificationDate -date "2030-02-07 23:22:47 +0000"
defaults write com.apple.SoftwareUpdate UserNotificationDate -date "2030-02-07 23:22:47 +0000"

# Restore boot sound on new macs
sudo nvram StartupMute=%00

# install powerline fonts
current_dir="$(pwd)"
cd "${HOME}/Downloads"
git clone https://github.com/powerline/fonts.git
cd fonts
bash install.sh
cd ..
rm -rf fonts
cd "${current_dir}"

# install Monaspace fonts
current_dir="$(pwd)"
cd "${HOME}/Downloads"
git clone https://github.com/githubnext/monaspace.git
cd monaspace
bash ./util/install_macos.sh
cd ..
rm -rf monaspace
cd "${current_dir}"


# Check if brew is installed; if not, install brew
has_brew=`which brew 2>/dev/null`
if [[ -z $has_brew ]]
then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

brew_taps_to_add=(
    'homebrew/cask'
    'jlhonora/lsusb'
    'homebrew/cask-fonts'
)

for tap in "${brew_taps_to_add[@]}"; do
    brew tap $tap
done

brew update && brew upgrade

brew_packages_to_install=(
    'arp-scan'
    'awscli'
    'bash-completion'
    'bash'
    'bat'
    'blender'
    'blueutil'
    'chatgpt'
    'claude'
    'colordiff'
    'coreutils'
    'cowsay'
    'cryptography'
    'diff-pdf'
    'docker-buildx'
    'docker-completion'
    'docker-compose'
    'docker-machine'
    'docker'
    'figlet'
    'findutils'
    'fswatch'
    'gawk'
    'gcc'
    'ghostscript'
    'glib'
    'gnu-getopt'
    'gnu-indent'
    'gnu-sed'
    'gnu-sed'
    'gnu-tar'
    'gnutls'
    'google-cloud-sdk'
    'google-chrome'
    'graphviz'
    'grep'
    'homebrew/cask/macvim'
    'imagemagick'
    'inkscape'
    'jq'
    'lolcat'
    'lsusb'
    'macvim'
    'mas'
    'mosh'
    'nativefier'
    'neofetch'
    'ollama'
    'openblas'
    'openssl@3'
    'pigz'
    'poetry'
    'podman'
    'poetry'
    'python'
    'pyenv'
    'r'
    'rectangle'
    'ripgrep'
    'rsync'
    'ruby'
    'rust'
    'sentencepiece'
    'sl'
    'sqlite'
    'tailscale'
    'tmux'
    'tree'
    'utm'
    'uv'
    'visual-studio-code'
    'wget'
    'yarn'
    'vagrant'
    'virtualbox'
    'zsh-autosuggestions'
    'zsh-syntax-highlighting'
)


for package in "${brew_packages_to_install[@]}"; do
    has_package=$(brew list ${package} 2>/dev/null)
    if [[ -z $has_package ]]; then
        brew install $package
    else
        brew upgrade $package
    fi
done


brew_cask_to_install=(
    'blender'
    'claude'
    'cyberduck'             # sftp client
    'docker'
    'discord'               # chat app
    'eqmac'
    'figma'
    'font-fira-code'        # font with ligatures
    'google-cloud-sdk'
    'iterm2'                # terminal
    'lingon-x'              # manage startup items
    'notion'                # note taking
    'mactex'
    'orbstack'              # replacement for docker
    'slack'                 # chat app
    'spotify'               # music player
    'visual-studio-code'    # text editor
    'zoom'                  # video conferencing
)


for package in "${brew_cask_to_install[@]}"; do
    has_package=$(brew list ${package} 2>/dev/null)
    if [[ -z $has_package ]]; then
        brew install --cask $package
    else
        brew upgrade $package
    fi
done

# Install apps on the Mac AppStore
mas_install=(
    '497799835' # xcode
)

not_signed_in_mas="Not signed in"

while [ ! -z "${not_signed_in_mas}" ]; do
    not_signed_in_mas=$(mas account | grep "Not signed in")

    if [ ! -z "${not_signed_in_mas}" ]; then
        echo "Please Sign in the Mac App Store and press return when done... "
        read foo
        continue
    fi

    for mas_app in "${mas_install[@]}"; do
        has_mas_app=$(mas list | grep $mas_app 2>/dev/null)
        if [[ -z $has_mas_app ]]; then
            mas install $mas_app
        fi
    done
done


function install_from_repo () {
    github_repo_name="${1}"

    # get release URL
    uri="$(curl https://api.github.com/repos/${github_repo_name}/releases | jq -r '.[0].assets[0].browser_download_url')"

    # make a temp dir where to download stuff
    repo_dir="/tmp/$(echo ${github_repo_name} | tr '/' '_')"
    mkdir -p ${repo_dir}

    # download the file
    gh_fn="$(basename ${uri})"
    gh_fp="${repo_dir}/${gh_fn}"
    wget ${uri} -O ${gh_fp}

    # check extension, decompress accordingly
    gh_ext="${gh_fn##*.}"

    if [ "${gh_ext}" == "gz" ] || [ "${gh_ext}" == "xz" ]; then
        tar -xf "${gh_fp}" -C "${repo_dir}"
    elif [ "${gh_ext}" == "zip" ]; then
        unzip ${gh_fp} -d "${repo_dir}"
    fi

    for app in $(ls --color=no "${repo_dir}"); do
        app_ext="${app##*.}"
        if [ "${app_ext}" == "app" ]; then
            cp -rf "${repo_dir}/${app}" "/Applications/"
            echo "Installed ${app}."
        fi
        if [ "${app_ext}" == "prefpane" ]; then
            cp -rf "${repo_dir}/${app}" "${HOME}/Library/PreferencePanes/"
            echo "Installed ${app}."
        fi
    done

    rm -rf ${repo_dir}
}

# Install apps from github releases
github_install=(
    # 'pallotron/yubiswitch'
)
for gh in "${github_install[@]}"; do
    install_from_repo "${gh}"
done

# Install "Oh My Zsh" + plugins
cd ~
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git $ZSH_CUSTOM/plugins/you-should-use
git clone https://github.com/fdellwing/zsh-bat.git $ZSH_CUSTOM/plugins/zsh-bat
echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc

# Hide folders I don't use
chflags hidden ~/Pictures ~/Music ~/Movies ~/Public

# Hide dev folders
chflags hidden ~/miniconda3

# <install from my setup>
current_dir="$(pwd)"
cd "${HOME}/Downloads"
git clone https://github.com/davidheineman/dotfiles.git
cd dotfiles

# Install fonts folder
find fonts -name "*.ttf" -exec cp {} ~/Library/Fonts/ \; && find fonts -name "*.otf" -exec cp {} ~/Library/Fonts/ \;

# Intall iterm2 profile
cp iterm2/iterm2-profiles.json ~/Library/Application\ Support/iTerm2/DynamicProfiles/Profiles.json

# Install custom binaries
cp acl.sh /usr/local/bin/acl
cp chat.sh /usr/local/bin/chat

cd ..
rm -rf dotfiles
cd "${current_dir}"
# </install from my setup>

# manual override on xcode installation to get xcrun working (for macos metal)
xcode-select --switch /Applications/Xcode.app/Contents/Developer

# Add latex to slack
curl -L https://github.com/thisiscam/math-with-slack/blob/master/math-with-slack.py/?raw=True > math-with-slack.py && python math-with-slack.py

echo "macOS setup completed."