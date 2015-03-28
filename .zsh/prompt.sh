#!/bin/zsh

# Prompt.

# Left-hand prompt.
PROMPT='
%{$MAGENTA%}%n%{$RESET%}@%{$GREEN%}%m%{$RESET%}:%{$CYAN%}%~%{$RESET%}
%{$YELLOW%}%?%{$RESET%} %# '

# Right prompt.
RPROMPT='${vcs_info_msg_0_}%{$RESET%} $(virtenv_indicator)'

# Prompt 2, to show why you are in a continued prompt. (if, for, while, etc.)
PROMPT2='%{$YELLOW%}%_%{$RESET%}> '
