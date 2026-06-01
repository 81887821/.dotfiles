#!/usr/bin/env bash

function is_dist_package_installed() {
    local package="$(package_mapping "${1}")"

    pacman -Qi "${package}"
}

function package_mapping() {
    local package="${1}"

    case "${package}" in
        'code')
            echo 'visual-studio-code-bin'
            ;;
        'xfce4')
            echo 'xfce4-session'
            ;;
        *)
            echo "${package}"
            ;;
    esac
}
