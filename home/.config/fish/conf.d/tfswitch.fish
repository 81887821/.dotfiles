set TFSWITCH_PATH /tmp/tfswitch-$USER
test -d $TFSWITCH_PATH; or mkdir $TFSWITCH_PATH

function switch_terraform --on-event fish_postexec
    if string match --regex '^cd\s' "$argv" >/dev/null
        if count *.tf >/dev/null; and grep -c "required_version" *.tf >/dev/null
            set -f TERRAFORM_PATH $TFSWITCH_PATH/$fish_pid
            command tfswitch --bin=$TERRAFORM_PATH; and alias terraform $TERRAFORM_PATH
        end
    end
end
