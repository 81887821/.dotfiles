if [ "$XDG_SESSION_TYPE" = "wayland" ]
    abbr --add xi 'wl-copy'
    abbr --add xo 'wl-paste'
    abbr --add xc 'wl-copy </dev/null'
else
    abbr --add xi 'xclip -in -selection clipboard'
    abbr --add xo 'xclip -out -selection clipboard'
    abbr --add xc 'xclip -in -selection clipboard </dev/null'
end
