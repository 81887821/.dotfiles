#!/bin/bash

readonly SLEEP_INTERVAL=0.5
readonly MAXIMUM_COUNT=240

function main() {
    local vm_name="$1"
    local vm_pid="$2"

    if [ "${vm_pid}" != "" ] && process_exists "${vm_pid}"; then
        /usr/bin/VBoxManage controlvm "${vm_name}" acpipowerbutton || return 1
        wait_for_process_exit "${vm_pid}" || return 1
    fi

    return 0
}

function wait_for_process_exit() {
    local pid="$1"
    local count=0

    while process_exists "${pid}"; do
        sleep "${SLEEP_INTERVAL}"
        count=$(expr ${count} + 1)

        if [ $count -ge ${MAXIMUM_COUNT} ]; then
            echo "Time-outed for waiting process ${pid}"
            return 1
        fi
    done

    return 0
}

function process_exists() {
    local pid="$1"

    if [ -d "/proc/${pid}" ]; then
        return 0
    else
        return 1
    fi
}

main "$@"
