#!/bin/bash

source "${0%/*}/library/path.sh" 2>/dev/null || source "library/path.sh" || exit 1
source "${0%/*}/library/common.sh" 2>/dev/null || source "library/common.sh" || exit 1
load_libraries 'package.sh' 'method.sh' 'argument.sh'

all_packages=false
overwrite=false
dry_run=false
create_parents=false
contexts=('default')
file_list="$(get_absolute_directory_path_of_executable)/dotfiles.csv"

function main() {
    parse_arguments "$@"
    install
}

function install() {
    local context method packages path

    while IFS=',' read context method packages path; do
        if contains "${context}" "${contexts[@]}"; then
            if ${all_packages} || is_installed "${packages}"; then
                ${method}_install "${path}"
            fi
        fi
    done <<< "$(tail -n+2 "${file_list}")"
}

main "$@"
