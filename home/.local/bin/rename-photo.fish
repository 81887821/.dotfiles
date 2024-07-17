#!/usr/bin/fish

for file in $argv
    set date_time (exiftool -d '%Y%m%d_%H%M%S' -datetimeoriginal $file | cut -d: -f2 | string trim)
    set new_name "$date_time.jpg"
    set i 0
    while [ -f $new_name ]
        set new_name "$date_time($i).jpg"
        set i (math $i + 1)
    end

    mv -vn $file $new_name
end
