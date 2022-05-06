#!/bin/bash

source "${0%/*}/library/common.sh" 2>/dev/null || source "library/common.sh" || exit 1
source "${0%/*}/library/path.sh" 2>/dev/null || source "library/path.sh" || exit 1
source "${0%/*}/library/package.sh" 2>/dev/null || source "library/package.sh" || exit 1

readonly dot_files=(
    '.config/fish/config.fish'
    '.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml'
    '.config/systemd/user/discord.service'
    '.config/systemd/user/ibus.service'
    '.config/systemd/user/vboxhost.service'
    '.config/systemd/user/vboxviewer@.service'
    '.config/systemd/user/vboxvm@.service'
    '.local/bin/vboxvm-stop.sh'
    '.config/systemd/user/tmux.service'
)
readonly dot_file_packages=(
    'fish'
    'xfce4'
    'discord firejail systemd'
    'ibus systemd'
    'virtualbox systemd'
    'virtualbox systemd'
    'virtualbox systemd'
    'virtualbox systemd'
    'tmux systemd'
)

link_only_installed=true
ln_flags=''
dry_run=false
create_parent=false

function main() {
    parse_arguments "$@"

    if ${link_only_installed}; then
        link_installed
    else
        link_all
    fi
}

function parse_arguments() {
    while [ $# -gt 0 ]; do
        case "$1" in
            '-a' | '--all')
                link_only_installed=false
                ;;
            '-f' | '--force')
                ln_flags='-f'
                ;;
            '-d' | '--dry-run')
                dry_run=true
                ;;
            '-p' | '--create-parent')
                create_parent=true
                ;;
            '-h' | '--help')
                print_usage
                exit 0
                ;;
            *)
                print_usage
                die "Invalid option: $1"
                ;;
        esac
        shift
    done
}

function print_usage() {
    echo "$0 [options]"
    echo "options: "
    echo "  -a or --all: link all files even if related package is not installed."
    echo "  -f or --force: use -f flag on ln"
    echo "  -d or --dry-run: print command without executing it"
    echo "  -p or --create-parent: create parent directory"
    echo "  -h or --help: print usage and exit."
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

    if ${create_parent}; then
        make_parent_directory "${link_file}"
    fi

    if ${dry_run}; then
        echo ln -s ${ln_flags} "$(to_relative_target_path "${target_file}" "${link_file}")" "${link_file}"
    else
        ln -s ${ln_flags} "$(to_relative_target_path "${target_file}" "${link_file}")" "${link_file}"
    fi
}

function make_parent_directory() {
    local parent="$(dirname "${0}")"

    if [ ! -e "${parent}" ]; then
        if ${dry_run}; then
            echo mkdir -p "${parent}"
        else
            mkdir -p "${parent}"
        fi
    fi
}

main "$@"
