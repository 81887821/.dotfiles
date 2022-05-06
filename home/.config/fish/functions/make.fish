function make --description 'GNU make utility to maintain groups of programs'
    set -l param -j(nproc)
    command make $param $argv
end
