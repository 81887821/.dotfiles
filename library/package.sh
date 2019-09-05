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

function get_package_finder() {
    local distribution="${1}"

    case "${distribution}" in
        "${ARCH_LINUX}")
            echo "pacman -Qi"
            ;;
        "${UBUNTU}")
            echo "apt-cache show"
            ;;
        *)
            die "Unknown distribution: ${distribution}"
            ;;
    esac
}

function get_package_mapping() {
    local distribution="${1}"

    case "${distribution}" in
        "${ARCH_LINUX}" | "${UBUNTU}")
            echo 'default_package_mapping'
            ;;
        *)
            die "Unknown distribution: ${distribution}"
            ;;
    esac
}

function default_package_mapping() {
    local package="${1}"

    case "${package}" in
        'fish')
            echo 'fish'
            ;;
        'xfce4')
            echo 'xfce4-session'
            ;;
        *)
            die "Unknown package: ${package}"
            ;;
    esac
}

function is_installed() {
    local package="${1}"
    local distribution="$(get_linux_distribution)"
    local find_package="$(get_package_finder "${distribution}")"
    local package_mapping="$(get_package_mapping "${distribution}")"

    ${find_package} "$("${package_mapping}" "${package}")" 1>/dev/null 2>/dev/null
    return $?
}
