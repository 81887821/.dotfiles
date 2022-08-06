#!/bin/bash

source "${0%/*}/library/common.sh" 2>/dev/null || source "library/common.sh" || exit 1
source "${0%/*}/library/path.sh" 2>/dev/null || source "library/path.sh" || exit 1
source "${0%/*}/library/package.sh" 2>/dev/null || source "library/package.sh" || exit 1

source "$(get_absolute_directory_path_of_executable)/arguments.sh" || die "Failed to source arguments.sh"

readonly dot_files=(
    '.config/fish/config.fish'
    '.config/fish/functions/ip.fish'
    '.config/fish/functions/ls.fish'
    '.config/fish/functions/make.fish'
    '.config/fish/functions/cgr.fish'
    '.config/fish/conf.d/color.fish'
    '.config/fish/conf.d/tfswitch.fish'
    '.config/fish/conf.d/tide_config.fish'
    '.config/fish/conf.d/kube_aliases.fish'
    '.config/fish/conf.d/kubectl_aliases.fish'
    '.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml'
    '.config/systemd/user/discord.service'
    '.config/systemd/user/ibus.service'
    '.config/systemd/user/vboxhost.service'
    '.config/systemd/user/vboxviewer@.service'
    '.config/systemd/user/vboxvm@.service'
    '.local/bin/vboxvm-stop.sh'
    '.config/systemd/user/tmux.service'
    '.local/bin/aur-install'
    '.local/bin/aur-uninstall'
    '.local/bin/aur-upgrade'
    '.local/lib/aur-common.sh'
)
readonly dot_file_packages=(
    'fish'
    'fish iproute2'
    'fish coreutils'
    'fish make'
    'fish git'
    'fish'
    'fish tfswitch'
    'fish'
    'fish kubectl'
    'fish kubectl'
    'xfce4'
    'discord firejail systemd'
    'ibus systemd'
    'virtualbox systemd'
    'virtualbox systemd'
    'virtualbox systemd'
    'virtualbox systemd'
    'tmux systemd'
    'pacman'
    'pacman'
    'pacman'
    'pacman'
)

link_only_installed=true
ln_flags=''
dry_run=false
create_parents=false

function main() {
    parse_arguments "$@"

    if ${link_only_installed}; then
        link_installed
    else
        link_all
    fi
}

function link_all() {
    local number_of_files="${#dot_files[@]}"
    local i=0

    while [ $i -lt $number_of_files ]; do
        make_link "${dot_files[$i]}"
        i=$(expr $i + 1)
    done
}

function link_installed() {
    local number_of_files="${#dot_files[@]}"
    local i=0

    while [ $i -lt $number_of_files ]; do
        if is_installed "${dot_file_packages[$i]}"; then
            make_link "${dot_files[$i]}"
        fi

        i=$(expr $i + 1)
    done
}

function make_link() {
    local target_file="$(get_absolute_directory_path_of_executable)/home/${1}"
    local link_file="${HOME}/${1}"

    if ${create_parents}; then
        make_parent_directory "${link_file}"
    fi

    if ${dry_run}; then
        echo ln -s ${ln_flags} "$(to_relative_target_path "${target_file}" "${link_file}")" "${link_file}"
    else
        ln -s ${ln_flags} "$(to_relative_target_path "${target_file}" "${link_file}")" "${link_file}"
    fi
}

function make_parent_directory() {
    local parent="$(dirname "${1}")"

    if [ ! -e "${parent}" ]; then
        if ${dry_run}; then
            echo mkdir -p "${parent}"
        else
            mkdir -p "${parent}"
        fi
    fi
}

main "$@"
