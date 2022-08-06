#!/bin/bash

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
