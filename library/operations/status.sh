#!/bin/bash

function status() {
    local context method packages path outputs

    while IFS=',' read context method packages path; do
        if contains "${context}" "${contexts[@]}"; then
            if ${all_packages} || is_installed "${packages}"; then
                outputs="$(${method}_state "${path}" 2>&1)"
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
                        echo "${RESULT_MODIFIED} ${path}"
                        ;;
                    "${STATE_ERROR}")
                        echo "${RESULT_ERROR} ${path}"
                        echo "${method}_state returned STATE_ERROR"
                        echo "${outputs}"
                        ;;
                    *)
                        echo -e "${RESULT_ERROR} ${path}\nInvalid state: $?\n${outputs}"
                        ;;
                esac
            fi
        fi
    done <<< "$(tail -n+2 "${file_list}")"
}

function status_parse_arguments() {
    parse_arguments "$@"
}
