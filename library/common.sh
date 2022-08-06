#!/bin/bash

function error() {
    echo "$@" 1>&2
}

function die() {
    error "$@"
    exit 1
}

function load_libraries() {
    local library

    for library in "$@"; do
        source "$(get_absolute_directory_path_of_executable)/library/${library}" || die "Failed to source ${library}"
    done
}

function contains() {
    local value="${1}"; shift
    local array=("$@")
    local element

    for element in "${array[@]}"; do
        if [ "${element}" == "${value}" ]; then
            return 0
        fi
    done

    return 1
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
