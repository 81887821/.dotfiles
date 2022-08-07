#!/bin/bash

function load() {
    local context method packages path outputs

    while IFS=',' read context method packages path; do
        if contains "${context}" "${contexts[@]}"; then
            if ${all_packages} || is_installed "${packages}"; then
                ${method}_state "${path}"
                case $? in
                    "${STATE_UP_TO_DATE}")
                        echo "${RESULT_UP_TO_DATE} ${path}"
                        ;;
                    "${STATE_NOT_INSTALLED}")
                        echo "${RESULT_NOT_INSTALLED} ${path}"
                        ;;
                    "${STATE_OUTDATED}")
                        echo "${RESULT_OUTDATED} ${path}"
                        ;;
                    "${STATE_MODIFIED}")
                        if outputs="$(${method}_load "${path}")"; then
                            echo "${RESULT_OK} ${path}"
                        else
                            echo "${RESULT_FAILED} ${path}"
                            echo "${outputs}"
                        fi
                        ;;
                    *)
                        echo -e "${RESULT_ERROR} ${path}\nFailed to get state: $?"
                        ;;
                esac
            fi
        fi
    done <<< "$(tail -n+2 "${file_list}")"
}

function load_parse_arguments() {
    parse_arguments "$@"
}
