set --export DOTNET_CLI_TELEMETRY_OPTOUT 1


if [ -d $HOME/bin ]
  set PATH $PATH "$HOME/bin"
end


function ls --description 'List contents of directory'
  set -l param --color=auto --group-directories-first
  if isatty 1
    set param $param --indicator-style=classify
  end
  command ls $param $argv
end


# Regular syntax highlighting colors
set -U fish_color_normal normal
set -U fish_color_command --bold
set -U fish_color_param cyan
set -U fish_color_redirection brblue
set -U fish_color_comment red
set -U fish_color_error brred
set -U fish_color_escape bryellow --bold
set -U fish_color_operator bryellow
set -U fish_color_end brmagenta
set -U fish_color_quote yellow
set -U fish_color_autosuggestion 555 brblack
set -U fish_color_user brgreen

set -U fish_color_host normal
set -U fish_color_valid_path --underline

set -U fish_color_cwd green
set -U fish_color_cwd_root red

# Background color for matching quotes and parenthesis
set -U fish_color_match --background=brblue

# Background color for search matches
set -U fish_color_search_match bryellow --background=brblack

# Background color for selections
set -U fish_color_selection white --bold --background=brblack
set -U fish_color_cancel -r

# Pager colors
set -U fish_pager_color_prefix white --bold --underline
set -U fish_pager_color_completion
set -U fish_pager_color_description B3A06D yellow
set -U fish_pager_color_progress brwhite --background=cyan

# Directory history colors
set -U fish_color_history_current --bold
