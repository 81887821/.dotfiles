#!/bin/bash

readonly STATE_UP_TO_DATE=0
readonly STATE_NOT_INSTALLED=1
readonly STATE_OUTDATED=2
readonly STATE_MODIFIED=3
readonly STATE_ERROR=4

readonly METHODS=('ln' 'cp' 'gpg')

function load_methods() {
    local method
    for method in "${METHODS[@]}"; do
        source "${DOT_ROOT}/library/methods/${method}.sh" || die "Failed to load method: ${method}"
    done
}

load_methods
