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
defaults write com.apple.dock tilesize -int 10
defaults write com.apple.dock autohide-time-modifier -float 20000000000
killall Dock

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
    'bash'
    'coreutils'
    'bash-completion'
    'tmux'
    'macvim'
    'homebrew/cask/macvim'
    'mosh'
    'blueutil'
    'gnu-sed'
    'rsync'
    'tree'
    'glib'
    'colordiff'
    'mas'
    'nativefier'
    'jq'
    'findutils'
    'openblas'
    'gnu-tar'
    'gnu-sed'
    'gawk'
    'gnutls'
    'gnu-indent'
    'gnu-getopt'
    'grep'
    'fswatch'
    'wget'
    'zsh-autosuggestions'
    'pigz'
    'lsusb'
    'diff-pdf'
    'ripgrep'
    'poetry'
    'figlet'
    'lolcat'
    'bat'
    'google-cloud-sdk'
    'inkscape'
    'visual-studio-code'
    'sqlite'
    'sl'
    'awscli'
    'cowsay'
    'docker'
    'poetry'
    'python'
    'arp-scan'
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
    'iterm2'                # terminal
    'slack'                 # chat app
    'spotify'               # music player
    'visual-studio-code'    # text editor
    'lingon-x'              # manage startup items
    'font-fira-code'        # font with ligatures
    'discord'               # chat app
    'orbstack'              # replacement for docker
    'zoom'                  # video conferencing
    'notion'                # note taking
    'cyberduck'             # sftp client
)


for package in "${brew_cask_to_install[@]}"; do
    has_package=$(brew list ${package} 2>/dev/null)
    if [[ -z $has_package ]]; then
        brew install --cask $package
    else
        brew upgrade $package
    fi
done

mas_install=(
    # '429449079'     # Patterns
    # '425424353'     # The Unarchiver
    # '403304796'     # iNet Network Scanner
    # '956377119'     # WorldClock
    # '1289583905'    # Pixelmator Pro
    # '1592917505'    # Noir
    # '992115977'     # image2icon
    # '1569813296'    # 1Password For Safari
    # '1320666476'    # Wipr
    # '2143935391'    # OpenCat
    # '1502111349'    # PDF Squeezer
    # '1475387142'    # TailScale
    # '1376402589'    # Stop The Maddenss
    # '1179623856'    # Pastebot
    # '441258766'     # Magnet
    # '1545870783'    # Color Picker
    # '899247664'     # TestFlight
    # '904280696'     # Things
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
    # 'Lord-Kamina/SwiftDefaultApps'
    # 'pallotron/yubiswitch'
)
for gh in "${github_install[@]}"; do
    install_from_repo "${gh}"
done

# bash ${script_dir}/bootstrap.sh

# Install Oh My Zsh + plugins
cd ~
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git $ZSH_CUSTOM/plugins/you-should-use
git clone https://github.com/fdellwing/zsh-bat.git $ZSH_CUSTOM/plugins/zsh-bat
echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc

echo "macOS setup completed."