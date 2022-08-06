#!/bin/bash

readonly ARCH_LINUX='Arch Linux'
readonly UBUNTU='Ubuntu'

function get_linux_distribution() {
    if [ -r '/etc/os-release' ]; then
        source /etc/os-release || die "Failed to source /etc/os-release"
        echo "${NAME}"
    else
        die "Cannot read /etc/os-release"
    fi
}

function load_package_functions() {
    local distribution="${1}"
    local library_path="${DOT_ROOT}/library/distributions/${distribution}.sh"

    if [ "${distribution}" == "" ]; then
        die "No distribution information."
    elif [ -f "${library_path}" ]; then
        source "${library_path}" || die "Loading ${library_path} failed."
    else
        die "Library for ${distribution} does not exist."
    fi
}

function is_installed() {
    local packages="${@}"
    local package

    for package in ${packages}; do
        $(get_package_finder) "$(package_mapping "${package}")" 1>/dev/null 2>/dev/null || return 1
    done

    return 0
}

load_package_functions "$(get_linux_distribution)"
