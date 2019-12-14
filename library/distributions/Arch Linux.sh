#!/bin/bash

function get_package_finder() {
    echo 'pacman -Qi'
}

function package_mapping() {
    local package="${1}"

    case "${package}" in
        'xfce4')
            echo 'xfce4-session'
            ;;
        *)
            echo "${package}"
            ;;
    esac
}
