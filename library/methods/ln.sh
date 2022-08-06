#!/bin/bash

function ln_install() {
    local target_file="$(get_absolute_directory_path_of_executable)/home/${1}"
    local link_file="${HOME}/${1}"
    local flags='-s'

    if ${overwrite}; then
        flags="${flags} -f"
    fi

    if ${create_parents}; then
        make_parent_directory "${link_file}"
    fi

    if ${dry_run}; then
        echo ln ${flags} "$(to_relative_target_path "${target_file}" "${link_file}")" "${link_file}"
    else
        ln ${flags} "$(to_relative_target_path "${target_file}" "${link_file}")" "${link_file}"
    fi
}

function ln_remove() {
    local link_file="${HOME}/${1}"

    if ${dry_run}; then
        echo rm "${link_file}"
    else
        rm "${link_file}"
    fi
}

function ln_load() {
    local target_file="$(get_absolute_directory_path_of_executable)/home/${1}"
    local link_file="${HOME}/${1}"

    ln_state ${1}
    case $? in
        "${STATE_UP_TO_DATE}" | "${STATE_NOT_INSTALLED}")
            return 0
            ;;
        "${STATE_OUTDATED}" | "${STATE_MODIFIED}")
            if ${dry_run}; then
                echo cp --reflink=auto "${link_file}" "${target_file}"
            else
                cp --reflink=auto "${link_file}" "${target_file}"
            fi
            ;;
        *)
            error "ln_load: Invalid state: $?"
            ;;
    esac
}

function ln_state() {
    local target_file="$(get_absolute_directory_path_of_executable)/home/${1}"
    local link_file="${HOME}/${1}"
    local realative_link_target="$(to_relative_target_path "${target_file}" "${link_file}")"

    if [ ! -e "${link_file}" ]; then
        return "${STATE_NOT_INSTALLED}"
    elif [ ! -L "${link_file}" ]; then
        return "${STATE_MODIFIED}"
    elif [ "$(readlink -n "${link_file}")" != "${realative_link_target}" ]; then
        return "${STATE_MODIFIED}"
    else
        return "${STATE_UP_TO_DATE}"
    fi
}
