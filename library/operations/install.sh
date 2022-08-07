#!/bin/bash

function install() {
    local context method packages path outputs

    while IFS=',' read context method packages path; do
        if contains "${context}" "${contexts[@]}"; then
            if ${all_packages} || is_installed "${packages}"; then
                ${method}_state "${path}"
                case $? in
                    "${STATE_UP_TO_DATE}")
                        echo "${RESULT_UP_TO_DATE} ${path}"
                        ;;
                    "${STATE_NOT_INSTALLED}" | "${STATE_OUTDATED}" | "${STATE_MODIFIED}")
                        if [ $? -eq "${STATE_MODIFIED}" ] && ! ${overwrite}; then
                            echo "${RESULT_MODIFIED} ${path}"
                            continue
                        fi

                        if outputs="$(${method}_install "${path}" 2>&1)"; then
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

function install_parse_arguments() {
    parse_arguments "$@"
}
