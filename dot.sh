#!/bin/bash

readonly REAL_EXECUTABLE_PATH="$(realpath "$0")"
readonly DOT_ROOT="${REAL_EXECUTABLE_PATH%/*}"
source "${DOT_ROOT}/library/common.sh" 2>/dev/null || exit 1
load_libraries 'path.sh' 'package.sh' 'method.sh' 'argument.sh' 'color.sh'

all_packages=false
overwrite=false
dry_run=false
create_parents=false
contexts=('default')
file_list="${DOT_ROOT}/dotfiles.csv"

function do_operation() {
    local operation="${1}"; shift
    local operation_path="${DOT_ROOT}/library/operations/${operation}.sh"

    if [ -f "${operation_path}" ]; then
        source "${operation_path}"
        ${operation}_parse_arguments "$@"
        ${operation}
    else
        print_help
        return 1
    fi
}

function print_help() {
    local operation

    echo "$(basename $0) OPERATION [OPTIONS]"
    echo "Available operations: "
    for operation in $(ls "${DOT_ROOT}/library/operations"); do
        echo "    ${operation%.sh}"
    done
}

do_operation "$@"
