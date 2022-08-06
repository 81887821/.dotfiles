#!/bin/bash

function error() {
    echo "$@" 1>&2
}

function die() {
    error "$@"
    exit 1
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
