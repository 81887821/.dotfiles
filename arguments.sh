#!/bin/bash

function parse_arguments() {
    local arguments=$(getopt --options adfhp --longoptions all,dry-run,force,help,create-parents --name $(basename ${0}) -- "$@")
    if [ $? -ne 0 ]; then
        print_usage
        exit 1
    fi

    eval set -- "${arguments}"
    while true; do
        case "$1" in
            '-a' | '--all')
                link_only_installed=false
                ;;
            '-d' | '--dry-run')
                dry_run=true
                ;;
            '-f' | '--force')
                ln_flags='-f'
                ;;
            '-h' | '--help')
                print_usage
                exit 0
                ;;
            '-p' | '--create-parents')
                create_parents=true
                ;;
            '--')
                shift
                break
                ;;
            *)
                print_usage
                die "Invalid option: $1"
                ;;
        esac
        shift
    done
}

function print_usage() {
    echo "$0 [options]"
    echo "options: "
    echo "  -a or --all: link all files even if related package is not installed."
    echo "  -d or --dry-run: print command without executing it"
    echo "  -f or --force: use -f flag on ln"
    echo "  -h or --help: print usage and exit."
    echo "  -p or --create-parents: create parent directory"
}
