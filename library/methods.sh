#!/bin/bash

readonly STATE_UP_TO_DATE=0
readonly STATE_NOT_INSTALLED=1
readonly STATE_OUTDATED=2
readonly STATE_MODIFIED=3
readonly STATE_ERROR=4
readonly STATE_NOT_IMPLEMENTED=5

readonly METHODS=('ln' 'cp')

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

function load_methods() {
    local method
    for method in "${METHODS[@]}"; do
        source "$(get_absolute_directory_path_of_executable)/library/methods/${method}.sh" || die "Failed to load method: ${method}"
    done
}

load_methods
