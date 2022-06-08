function my_git_prompt_info() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    GIT_STATUS=$(git_prompt_status)
    [[ -n $GIT_STATUS ]] && GIT_STATUS=" $GIT_STATUS"
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$GIT_STATUS$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

local name='%{$fg[green]%}%n%{$reset_color%}@'
local gitpinfo='$(my_git_prompt_info)%{$reset_color%}'
local error='%(?..%{$fg[red]%}[%{$fg_bold[red]%}%?%{$reset_color%}%{$fg[red]%}]%{$reset_color%})'

# Collapsed working directory
_fishy_collapsed_wd() {
    local i pwd
    pwd=("${(s:/:)PWD/#$HOME/~}")
    if (( $#pwd > 1 )); then
        for i in {1..$(($#pwd-1))}; do
        if [[ "$pwd[$i]" = .* ]]; then
            pwd[$i]="${${pwd[$i]}[1,2]}"
        else
            pwd[$i]="${${pwd[$i]}[1]}"
        fi
        done
    fi
    echo "${(j:/:)pwd}"
}

# Test to see if user is root
if [[ $EUID == 0 ]]; then
    local dir='%{$fg[red]%}$(_fishy_collapsed_wd)%{$reset_color%} '
    local arrow='%B#%b '
else
    local dir='%{$fg[green]%}$(_fishy_collapsed_wd)%{$reset_color%} '
    local arrow='%B»%b '
fi

local host='%{$fg[yellow]%}%m '

PROMPT=$name$host$dir$gitpinfo$error$arrow

# Shows return arrow when output does not end in newline
PROMPT_EOL_MARK='↵ '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=") %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%%"
ZSH_THEME_GIT_PROMPT_ADDED="+"
ZSH_THEME_GIT_PROMPT_MODIFIED="*"
ZSH_THEME_GIT_PROMPT_RENAMED="~"
ZSH_THEME_GIT_PROMPT_DELETED="!"
ZSH_THEME_GIT_PROMPT_UNMERGED="?"

# Set styles for zsh-syntax-highlighting plugin
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[arg0]=fg=4
ZSH_HIGHLIGHT_STYLES[command]=fg=4
ZSH_HIGHLIGHT_STYLES[alias]=fg=4
ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=4
ZSH_HIGHLIGHT_STYLES[precommand]=fg=4,bold
ZSH_HIGHLIGHT_STYLES[builtin]=fg=6,bold
ZSH_HIGHLIGHT_STYLES[default]=fg=12
ZSH_HIGHLIGHT_STYLES[path]=fg=12
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=5
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=208,bold
ZSH_HIGHLIGHT_STYLES[assign]=fg=14
