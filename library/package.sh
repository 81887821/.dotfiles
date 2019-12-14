#!/bin/bash

readonly ARCH_LINUX='Arch Linux'
readonly UBUNTU='Ubuntu'

function get_linux_distribution() {
    if [ -r '/etc/os-release' ]; then
        source /etc/os-release
        echo "${NAME}"
    else
        die "Cannot read /etc/os-release"
    fi
}

function load_functions() {
    local distribution="${1}"
    local library_path="$(get_absolute_directory_path_of_executable)/library/distributions/${distribution}.sh"

    if [ -f "${library_path}" ]; then
        source "${library_path}" || die "Loading ${library_path} failed."
    else
        die "Library for ${distribution} does not exist."
    fi
}

function is_installed() {
    local packages="${@}"
    local distribution="$(get_linux_distribution)"
    local package

    load_functions "${distribution}"

    for package in ${packages}; do
        $(get_package_finder) "$(package_mapping "${package}")" 1>/dev/null 2>/dev/null || return 1
    done

    return 0
}
