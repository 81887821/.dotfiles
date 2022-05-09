#!/bin/bash

readonly AUR_DIRECTORY="${HOME}/.aur"
working_directory="${HOME}/.aur"
package_directory="${HOME}/.aur-packages"

function error() {
    echo "$@" 1>&2
    return 1
}

function die() {
    error "$@"
    exit 1
}

function ask_yes_no() {
    local prompt="${1}"
    local assume_yes="${2}"
    local answer

    if [ "${assume_yes}" == "" ] || ! ${assume_yes}; then
        prompt="${prompt} [y/N]"
        assume_yes=false
    else
        prompt="${prompt} [Y/n]"
    fi

    while true; do
        read -p "${prompt} " answer
        if [ "${answer}" == "" ]; then
            ${assume_yes}; return $?
        elif [ "$answer" == "Y" ] || [ "$answer" == "y" ]; then
            return 0
        elif [ "$answer" == "N" ] || [ "$answer" == "n" ]; then
            return 1
        fi
    done
}

function prepare_directory() {
    local use_tmpfs="${1}"

    mkdir "${AUR_DIRECTORY}" >/dev/null 2>/dev/null
    if ${use_tmpfs}; then
        working_directory=$(mktemp -d) || die "Failed to create working directory"
        package_directory=$(mktemp -d) || die "Failed to create package directory"
    else
        if [ -d "${package_directory}" ]; then
            rmdir "${package_directory}" || die "${package_directory} is not empty"
        fi
        mkdir -p "${package_directory}" || die "Failed to create package directory"
    fi
}

function clean_up_directory() {
    local use_tmpfs="${1}"

    if ${use_tmpfs}; then
        rm -rf "${working_directory}" || error "Failed to remove ${working_directory}"
    fi
    rm -r "${package_directory}" || error "Failed to remove ${package_directory}"
}

function check_package_all() {
    local package="${1}"

    cd "${AUR_DIRECTORY}/${package}"
    less -- PKGBUILD *
}

function check_package_diff() {
    local head="${1}"
    local upstream="${2}"

    git diff "${head}" "${upstream}"
}

function build_package() {
    local package="${1}"

    if [ "${working_directory}" != "${AUR_DIRECTORY}" ]; then
        cp -r "${AUR_DIRECTORY}/${package}" "${working_directory}/${package}" || error "Failed to copy package ${package} to working directory" || return 1
    fi

    cd "${working_directory}/${package}"
    makepkg -sc || error "makepkg failed" || return 1
    mv *.pkg* "${package_directory}" || error "Failed to move package" || return 1

    if [ "${working_directory}" != "${AUR_DIRECTORY}" ]; then
        cd "${working_directory}"
        rm -rf "${working_directory}/${package}" || error "Failed to remove ${working_directory}/${package}"
    else
        git clean -df >/dev/null 2>/dev/null
        git clean -Xf >/dev/null 2>/dev/null
    fi
}

function install_built_packages() {
    if ls "${package_directory}"/*.pkg* >/dev/null 2>/dev/null; then
        sudo pacman -U --needed "${package_directory}"/*.pkg*
    fi
}

function abort_installation() {
    local package

    while [ $# -gt 0 ]; do
        package="${1}"

        if ! pacman -Qi "${package}" >/dev/null 2>/dev/null; then
            rm -rf "${AUR_DIRECTORY}/${package}"
        fi
        shift
    done
}
