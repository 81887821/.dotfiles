set TFSWITCH_PATH $HOME/.local/tfswitch
set PATH $TFSWITCH_PATH $PATH

function switch_terraform --on-event fish_postexec
    if string match --regex '^cd\s' "$argv" > /dev/null
        if count *.tf > /dev/null; and grep -c "required_version" *.tf > /dev/null
            command tfswitch --bin=$TFSWITCH_PATH/terraform
        end
    end
end
