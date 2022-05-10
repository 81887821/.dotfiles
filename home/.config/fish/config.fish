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

if [ -d /opt/asdf-vm ]
    source /opt/asdf-vm/asdf.fish
end

if which ruby >/dev/null 2>/dev/null
    set --export GEM_HOME (ruby -e 'puts Gem.user_dir')
    set --export PATH $PATH "$GEM_HOME/bin"
end
