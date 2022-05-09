function cgr --description 'Change directory to Git Root'
    set -l git_root (git rev-parse --show-toplevel) || return $status
    cd $git_root
end
