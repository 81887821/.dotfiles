#!/bin/bash

function print_result_string() {
    local message="${1}"
    local color="${2}"
    local width="${3}"
    local left_spaces right_spaces i

    if [ "${#message}" -gt "${width}" ]; then
        error "make_result_string: message length is larger than width"
        left_spaces=0
        right_spaces=0
    else
        left_spaces=$(expr \( "${width}" - "${#message}" \) / 2)
        right_spaces=$(expr "${width}" - "${#message}" - "${left_spaces}")
    fi

    echo -n "${BOLD}["
 
    i=0
    while [ "${i}" -lt "${left_spaces}" ]; do
        echo -n ' '
        i=$(expr "${i}" + 1)
    done

    echo -n "${color}${message}"
    
    i=0
    while [ "${i}" -lt "${right_spaces}" ]; do
        echo -n ' '
        i=$(expr "${i}" + 1)
    done

    echo -n "${WHITE}]${RESET}"
}

readonly RESULT_OK="$(print_result_string 'OK' "${GREEN}" 12)"
readonly RESULT_FAILED="$(print_result_string 'Failed' "${RED}" 12)"
readonly RESULT_UP_TO_DATE="$(print_result_string 'UpToDate' "${GREEN}" 12)"
readonly RESULT_NOT_INSTALLED="$(print_result_string 'NotInstalled' "${WHITE}" 12)"
readonly RESULT_OUTDATED="$(print_result_string 'Outdated' "${YELLO}" 12)"
readonly RESULT_MODIFIED="$(print_result_string 'Modified' "${YELLO}" 12)"
readonly RESULT_ERROR="$(print_result_string 'Error' "${RED}" 12)"
