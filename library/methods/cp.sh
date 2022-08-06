#!/bin/bash

function cp_install() {
    local source="$(get_absolute_directory_path_of_executable)/home/${1}"
    local destination="${HOME}/${1}"
    local flags='--reflink=auto'

    if ! ${overwrite}; then
        flags="${flags} -n"
    fi

    if ${create_parents}; then
        make_parent_directory "${destination}"
    fi

    if ${dry_run}; then
        echo cp ${flags} "${source}" "${destination}"
    else
        cp ${flags} "${source}" "${destination}"
    fi
}

function cp_uninstall() {
    local target="${HOME}/${1}"

    if ${dry_run}; then
        echo rm "${target}"
    else
        rm "${target}"
    fi
}

function cp_load() {
    local destination="$(get_absolute_directory_path_of_executable)/home/${1}"
    local source="${HOME}/${1}"
    local flags='--reflink=auto'

    if ${dry_run}; then
        echo cp ${flags} "${source}" "${destination}"
    else
        cp ${flags} "${source}" "${destination}"
    fi
}

function cp_state() {
    local source="$(get_absolute_directory_path_of_executable)/home/${1}"
    local destination="${HOME}/${1}"

    if [ ! -e "${destination}" ]; then
        return "${STATE_NOT_INSTALLED}"
    elif [ ! -f "${destination}" ]; then
        return "${STATE_MODIFIED}"
    elif [ "$(md5sum "${source}" | head -c32)" == "$(md5sum "${destination}" | head -c32)" ]; then
        return "${STATE_UP_TO_DATE}"
    elif [ "${destination}" -ot "${source}" ]; then
        return "${STATE_OUTDATED}"
    else
        return "${STATE_MODIFIED}"
    fi
}