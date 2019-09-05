#!/bin/bash

source "${0%/*}/library/common.sh" 2>/dev/null || source "library/common.sh" || exit 1
source "${0%/*}/library/path.sh" 2>/dev/null || source "library/path.sh" || exit 1
source "${0%/*}/library/package.sh" 2>/dev/null || source "library/package.sh" || exit 1

readonly files=(
    '.config/fish/config.fish'
    '.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml'
)
readonly packages=(
    'fish'
    'xfce4'
)

link_only_installed=true
ln_flags=''

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
            '--all')
                link_only_installed=false
                ;;
            '--force')
                ln_flags='-f'
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
    echo "  --all: link all files even if related package is not installed."
    echo "  --force: use -f flag on ln"
    echo "  -h or --help: print usage and exit."
}

function link_all() {
    local number_of_files="${#files[@]}"
    local i=0

    while [ $i -lt $number_of_files ]; do
        make_link "${files[$i]}"
        i=$(expr $i + 1)
    done
}

function link_installed() {
    local number_of_files="${#files[@]}"
    local i=0

    while [ $i -lt $number_of_files ]; do
        if is_installed "${packages[$i]}"; then
            make_link "${files[$i]}"
        fi

        i=$(expr $i + 1)
    done
}

function make_link() {
    local target_file="$(get_absolute_executable_directory)/home/${1}"
    local link_file="${HOME}/${1}"

    ln -s ${ln_flags} "$(to_relative_target_path "${target_file}" "${link_file}")" "${link_file}"
}

main "$@"
