#!/bin/bash

readonly gpg_recipients=(
    '92FF9BFB66103D26591660833DE3D0F0ED3BFA9D'
)
readonly gpg_common_flags='--status-file=/dev/null --batch --yes'

function gpg_install() {
    local source="${DOT_ROOT}/home/${1}"
    local destination="${HOME}/${1}"

    if ${create_parents}; then
        make_parent_directory "${destination}"
    fi

    if ${dry_run}; then
        echo gpg ${gpg_common_flags} --output "${destination}" --decrypt "${source}"
    else
        gpg ${gpg_common_flags} --output "${destination}" --decrypt "${source}"
    fi
}

function gpg_uninstall() {
    local target="${HOME}/${1}"

    if ${dry_run}; then
        echo rm "${target}"
    else
        rm "${target}"
    fi
}

function gpg_load() {
    local destination="${DOT_ROOT}/home/${1}"
    local source="${HOME}/${1}"
    local recipient recipient_flags

    if [ "${#gpg_recipients}" -eq 0 ]; then
        die "gpg_load: No recipient"
    fi

    for recipient in "${gpg_recipients[@]}"; do
        recipient_flags="${recipient_flags} --recipient=${recipient}!"
    done

    if ${dry_run}; then
        echo gpg ${gpg_common_flags} --armor --output "${destination}" ${recipient_flags} --encrypt --sign "${source}"
    else
        gpg ${gpg_common_flags} --armor --output "${destination}" ${recipient_flags} --encrypt --sign "${source}"
    fi
}

function gpg_state() {
    local source="${DOT_ROOT}/home/${1}"
    local destination="${HOME}/${1}"

    if [ ! -e "${destination}" ]; then
        return "${STATE_NOT_INSTALLED}"
    elif [ ! -f "${destination}" ]; then
        return "${STATE_MODIFIED}"
    elif [ "$(gpg ${gpg_common_flags} --decrypt "${source}" 2>/dev/null | md5sum | head -c32)" == "$(md5sum "${destination}" | head -c32)" ]; then
        return "${STATE_UP_TO_DATE}"
    elif [ "${destination}" -ot "${source}" ]; then
        return "${STATE_OUTDATED}"
    else
        return "${STATE_MODIFIED}"
    fi
}
