#!/usr/bin/env bash

function get_nix_system_packages() {
    local parameters=()

    if [ -n "${NH_FLAKE}" ]; then
        parameters=("-F" "${NH_FLAKE}")
    fi

    nixos-option "${parameters[@]}" environment.systemPackages | grep derivation
}

nix_system_packages="$(get_nix_system_packages)"

function is_dist_package_installed() {
    local package="$(package_mapping "${1}")"

    echo "${nix_system_packages}" | grep "${package}"
}

function package_mapping() {
    local package="${1}"

    case "${package}" in
        *)
            echo "${package}"
            ;;
    esac
}
