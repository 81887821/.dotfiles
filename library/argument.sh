#!/bin/bash

function parse_arguments() {
    local arguments=$(getopt --options ac:de:fhl:p --longoptions all-packages,with-context:,dry-run,without-context:,overwrite,help,use-list:,create-parents --name $(basename ${0}) -- "$@")
    if [ $? -ne 0 ]; then
        print_usage
        exit 1
    fi

    eval set -- "${arguments}"
    while true; do
        case "$1" in
            '-a' | '--all-packages')
                all_packages=true
                ;;
            '-c' | '--with-context')
                contexts+=("$2")
                shift
                ;;
            '-d' | '--dry-run')
                dry_run=true
                ;;
            '-e' | '--without-context')
                local i=0
                local context_removed=false
                while [ ${i} -lt ${#contexts[@]} ]; do
                    if [ "${contexts[${i}]}" == "$2" ]; then
                        unset "contexts[${i}]"
                        context_removed=true
                        break
                    else
                        i=$(expr ${i} + 1)
                    fi
                done
                ${context_removed} || error "Ignored $1 $2: context was not selected"
                shift
                ;;
            '-f' | '--overwrite')
                overwrite=true
                ;;
            '-h' | '--help')
                print_usage
                exit 0
                ;;
            '-l' | '--use-list')
                file_list="$2"
                shift
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
    echo "$(basename $0) OPERATION [OPTIONS]"
    echo "options: "
    echo "  -a or --all-packages: install all files even if related package is not installed"
    echo "  -c or --with-context=CONTEXT: install files within the CONTEXT"
    echo "  -d or --dry-run: print command without executing it"
    echo "  -e or --without-context=CONTEXT: do not install files within the CONTEXT"
    echo "  -f or --overwrite: overwrite existing files"
    echo "  -h or --help: print usage and exit"
    echo "  -l or --use-list=FILE_LIST: use FILE_LIST instead of default dotfiles.csv"
    echo "  -p or --create-parents: create parent directory"
}
