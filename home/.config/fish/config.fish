set --export DOTNET_CLI_TELEMETRY_OPTOUT 1
set --export DBUS_SESSION_BUS_ADDRESS unix:path=/run/user/(id -u)/bus
set --export XDG_RUNTIME_DIR /run/user/(id -u)
set --export GPG_TTY (tty)
set --export COLORFGBG ";0"

test -d $HOME/.local/bin; and set PATH $PATH "$HOME/.local/bin"
if [ (id -u) = 0 ]
    test -d /usr/sbin -a ! -L /usr/sbin; and set PATH $PATH /usr/sbin
    test -d /usr/local/sbin -a ! -L /usr/local/sbin; and set PATH $PATH /usr/local/sbin
end
