#!/bin/bash

function get_absolute_directory_path_of_executable() {
    local executable_path="${0}"
    local absolute_path

    executable_path="${executable_path%/*}"
    if [ "${executable_path}" == "." ]; then
        # Handle case for "./script.sh"
        executable_path=""
    elif [ "${executable_path}" == "${0}" ]; then
        # Handle case for "bash script.sh"
        executable_path=""
    fi

    if [ "${executable_path:0:1}" == "/" ]; then
        absolute_path="${executable_path}"
    else
        absolute_path="$(pwd)/${executable_path}"
    fi

    absolute_path="${absolute_path%/}"
    echo "${absolute_path}"
}

function to_relative_target_path() {
    local target="${1#/}"
    local link="${2#/}"

    # Remove common parents
    while true; do
        local link_current="${link%%/*}"
        local target_current="${target%%/*}"

        if [ "${link_current}" == "" ] || [ "${target_current}" == "" ]; then
            break
        elif [ "${link_current}" == "${target_current}" ]; then
            link="${link#*/}"
            target="${target#*/}"
        else
            break
        fi
    done

    local parent_path=''

    link="${link%/*}/"
    while [ "${link}" != "" ]; do
        link="${link#*/}"
        parent_path="../${parent_path}"
    done

    echo "${parent_path}${target}"
}
