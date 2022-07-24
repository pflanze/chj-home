# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# NOTE: you can use ~/.bashrc_local for local changes (i.e. those that
# shouldn't make it to the Git repo), it is included at the end of
# this file.


# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

__ps1_show_exitcode () {
    local exitcode=$?
    # Have to make shell aware of non-printing character sequences,
    # and for this have to use \001 \002 over \[ \] .
    # (Also see https://mywiki.wooledge.org/BashFAQ/053 .)
    if [ "$exitcode" -ne 0 ]; then
	echo -ne '\001\033[01;41m\002'
	printf '%3d' "$exitcode"
	echo -ne '\001\033[00m\002'
	echo -n ' '
	echo -ne '\001\033[01;32m\002'
    else
	echo -ne '\001\033[01;42m\002'
	echo -n '  0'
	echo -ne '\001\033[00m\002'
	echo -n ' '
	echo -ne '\001\033[01;32m\002'
    fi
}

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color|xterm)
    PS1='$(__ps1_show_exitcode)\u@$CHJHOSTNAME\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    ;;
*)
    PS1='\u@$CHJHOSTNAME:\w\$ '
    ;;
esac

# If this is an xterm set the window title, via PROMPT_COMMAND
case "$TERM" in
    xterm*|rxvt*)
	PROMPT_COMMAND='echo -ne "\033]0;${USER}@$CHJHOSTNAME: ${PWD/$HOME/~}\007"'
	;;
    *)
	;;
esac


# enable color support of ls
if [ "$TERM" != "dumb" ]; then
    eval "$(dircolors -b)"
    ls () { command ls --color=auto "$@"; }
fi

possibly_cd () {
    if [ $# = 1 ]; then
        cd "$1"
    elif [ $# -gt 1 ]; then
        echo "too many arguments"
	false
    fi
}

_cd_then () {
    local to="$1"; shift
    if [ $# = 1 ]; then
        local old=$(pwd)
	local oldOLDPWD=$OLDPWD
        if cd "$to" && cd "$1"; then
	    OLDPWD=$old
	else
	    cd "$old"
	    OLDPWD=$oldOLDPWD
	fi
    elif [ $# -gt 1 ]; then
        echo "too many arguments"
	false
    else
	cd "$to"
    fi
}

u () { _cd_then .. "$@"; }
uu () { _cd_then ../.. "$@"; }
uuu () { _cd_then ../../.. "$@"; }
uuuu () { _cd_then ../../../.. "$@"; }
uuuuu () { _cd_then ../../../../.. "$@"; }
les () { less "$@"; }
c () { cd "$@"; }
cdnewdir () {
    if [ "$#" -eq 1 ]; then
        mkdir -p "$1" && cd "$1"
    else
        echo One argument required
	false
    fi
};
mvcdnewdir () {
    if [ "$#" -gt 1 ]; then
        mvnewdir "$@" && cd "${!#}"
    else
        echo At least two arguments expected
	false
    fi
};
mvcd () {
    if [ "$#" -gt 1 ]; then
        if [ -d "${!#}" ]; then
            mv "$@" && cd "${!#}"
        else
            # echo Last argument is not a directory
            if [ "$#" -eq 2 ]; then
                if [ -d "$1" ]; then
                    mv "$@" && cd "${!#}"
                else
                    echo Neither argument is a directory
		    false
                fi
            else
                echo More than two arguments and last one is not a directory
		false
            fi
        fi
    else
        echo At least two arguments expected
	false
    fi
}
_ls_newest () {
    lastdir --full -a -- "$@"
}
cd_newest_sisterfolder () {
    cd "$(_ls_newest ..)$"
}
cd_newest () {
    cd "$(_ls_newest .)"
}
cdn () {
    if [ $# -eq 0 ]; then
	cd_newest
    else
	cdnewdir "$@"
    fi
}
cdnn () {
    if [ $# -eq 0 ]; then
	cd_newest
        cd_newest
    else
	cd_newest
        cdnewdir "$@"
    fi
}
cdnnn () {
    if [ $# -eq 0 ]; then
	cd_newest
	cd_newest
        cd_newest
    else
	cd_newest
	cd_newest
        cdnewdir "$@"
    fi
}

_cgd_ () {
    local gd_="$1"
    shift
    if [ $# = 0 ]; then
        echo "Please give name-regex (and optionally index into result list)" >&2
        return 1
    fi
    local last="${@:$#:1}"
    local index=""
    local args
    declare -a args
    if printf '%s' "$last" | egrep -q '^[0-9]+$'; then
        index="$last"
        args=("${@:1:$(( $# - 1 ))}")
    else
        args=("$@")
    fi
    local res
    if ! res="$("$gd_" "${args[@]}")"; then
        return 1
    fi
    # (XX do these with builtins?)
    if [ -n "$res" ]; then
        local len
        len0="$(printf '%s' "$res" | wc -l)"
        if [ "$len0" -eq 0 ]; then
            cd "$res"
        else
            if [ -n "$index" ]; then
                if [ "$index" -le "$len0" ]; then
                    local item
                    if ! item="$(printf "%s" "$res" | skiplines "$index")"; then
                        return 1
                    fi
                    if ! item="$(printf "%s" "$item" | head -1)"; then
                        return 1
                    fi
                    cd "$item"
                else
                    echo "Index is pointing behind last item" >&2
                    false
                fi
            else
                local numbered
                numbered=$(printf '%s' "$res" | linenumbers)
                printf '*** More than one result, please give index:\n%s\n' "$numbered" >&2
                false
            fi
        fi
    else
        echo "Nothing found." >&2
        false
    fi
}
cgd () {
    _cgd_ gd "$@"
}
cgdi () {
    _cgd_ gdi "$@"
}
cgi () {
    _cgd_ gi "$@"
}
cgii () {
    _cgd_ gii "$@"
}

cdt () {
    if checkcreate-tmp-owner-dir; then
	cd "/tmp/$USER"
    fi
}
cdpwd () {
    cd "$(pwd -P)"
}

unlimit () {
    if [ $# -eq 0 ]; then
	ulimit -S -v unlimited
    else
	(
	    ulimit -S -v unlimited
	    exec "$@"
	)
    fi
}

cs () {
    cd ~/scratch
}

cb () {
    cd ~/bookmarks
    if [ $# -ge 1 ]; then
	cd "$1"
    fi
}
cj () {
    cd ~/bookmarks/j
    if [ $# -ge 1 ]; then
	cd "$1"
    fi
}

ce () {
    cd ~/exchange
    if [ $# -ge 1 ]; then
	cd "$1"
    fi
}


find () { my.find "$@"; }
df () { my.df "$@"; }

mv () { command mv -i "$@"; }
cp () { command cp -i "$@"; }
#rm () { command rm -i "$@"; }

rens () {
    if [ scratch != "$(basename "$(pwd)")" ]; then
	cd scratch
    fi
    ren -- "$(lastfile .)"
}

rensn () {
    cd scratch/
    ren -- "$(nonrenamed | tail -1 | ls2list)"
}

# rename scratch nonrenamed all
rensna () {
    cd scratch/
    ren-nonrenamed
}

settitle () {
    unset PROMPT_COMMAND
    /opt/chj/bin/settitle "$@"
}

if [ "$UID" -eq 0 ]; then
    tar () {
	echo "'tar': use tar-names or tar-numbers instead" >&2
	false
    }
fi


ps () {
    command ps --sort=start_time "$@"
}

lsof () {
    command lsof -nP "$@"
    # -n = no host names
    # -P = no port names
}

rxvt-fontsize () {
    eval "$(/opt/chj/bin/rxvt-fontsize "$@")"
}

# Utils which might be later in PATH than system ones:

ls () { /opt/chj/bin/ls --color=auto "$@"; } # XX is this still useful?
sort () { /opt/chj/bin/sort "$@"; }
smplayer () { /opt/chj/bin/smplayer "$@"; }
zless () { /opt/chj/bin/zless "$@"; }
xpdf () { /opt/chj/bin/xpdf "$@"; }
modprobe () { /opt/chj/bin/modprobe "$@"; }
halt () { /opt/chj/bin/halt "$@"; }
open () { /opt/chj/bin/open "$@"; }
suxterm () { /opt/chj/bin/suxterm "$@"; }
pdftotext () { /opt/chj/bin/pdftotext "$@"; }
gv () { /opt/chj/bin/gv "$@"; }
wg () { /opt/chj/bin/wg "$@"; }


# --- End -------------------------------------

# You may want to copy this to ~/.bashrc_local (and add other local
# changes):

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if [ -f /etc/bash_completion ]; then
#    . /etc/bash_completion
#fi

if [ -f ~/.bashrc_local ]; then
    source ~/.bashrc_local
fi
