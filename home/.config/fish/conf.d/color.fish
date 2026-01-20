# Regular syntax highlighting colors
set -g fish_color_normal normal
set -g fish_color_command --bold
set -g fish_color_param cyan
set -g fish_color_redirection brblue
set -g fish_color_comment red
set -g fish_color_error brred
set -g fish_color_escape bryellow --bold
set -g fish_color_operator bryellow
set -g fish_color_end brmagenta
set -g fish_color_quote yellow
set -g fish_color_autosuggestion 555 brblack
set -g fish_color_user brgreen

set -g fish_color_host normal
set -g fish_color_valid_path --underline

set -g fish_color_cwd green
set -g fish_color_cwd_root red

# Background color for matching quotes and parenthesis
set -g fish_color_match --background=brblue

# Background color for search matches
set -g fish_color_search_match bryellow --background=brblack

# Background color for selections
set -g fish_color_selection white --bold --background=brblack
set -g fish_color_cancel -r

# Pager colors
set -g fish_pager_color_prefix white --bold --underline
set -g fish_pager_color_completion
set -g fish_pager_color_description B3A06D yellow
set -g fish_pager_color_progress brwhite --background=cyan

# Directory history colors
set -g fish_color_history_current --bold
