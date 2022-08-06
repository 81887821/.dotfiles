#!/bin/bash

source "${0%/*}/library/common.sh" 2>/dev/null || source "library/common.sh" || exit 1
source "${0%/*}/library/path.sh" 2>/dev/null || source "library/path.sh" || exit 1
source "${0%/*}/library/package.sh" 2>/dev/null || source "library/package.sh" || exit 1
source "${0%/*}/library/methods.sh" 2>/dev/null || source "library/methods.sh" || exit 1

source "$(get_absolute_directory_path_of_executable)/arguments.sh" || die "Failed to source arguments.sh"

all_packages=false
overwrite=false
dry_run=false
create_parents=false
contexts=('default')

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
    done <<< "$(tail -n+2 "$(get_absolute_directory_path_of_executable)/dotfiles.csv")"
}

main "$@"
