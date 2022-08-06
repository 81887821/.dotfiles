#!/bin/bash

source "${0%/*}/library/path.sh" 2>/dev/null || source "library/path.sh" || exit 1
source "${0%/*}/library/common.sh" 2>/dev/null || source "library/common.sh" || exit 1
load_libraries 'package.sh' 'method.sh' 'argument.sh' 'color.sh'

all_packages=false
overwrite=false
dry_run=false
create_parents=false
contexts=('default')
file_list="$(get_absolute_directory_path_of_executable)/dotfiles.csv"

function do_operation() {
    local operation="${1}"; shift
    local operation_path="$(get_absolute_directory_path_of_executable)/library/operations/${operation}.sh"

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
    for operation in $(ls "$(get_absolute_directory_path_of_executable)/library/operations"); do
        echo "    ${operation%.sh}"
    done
}

do_operation "$@"
