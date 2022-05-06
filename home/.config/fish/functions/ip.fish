function ip --description 'Show / manipulate routing, network devices, interfaces and tunnels'
    set -l param --color=auto
    command ip $param $argv
end
