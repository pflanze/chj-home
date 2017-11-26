# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples


# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color)
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    ;;
*)
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    ;;
esac

# Comment in the above and uncomment this below for a color prompt
#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac


# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    ls() { command ls --color=auto "$@"; }
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if [ -f /etc/bash_completion ]; then
#    . /etc/bash_completion
#fi

u() { cd ..; }
uu() { cd ../..; }
uuu() { cd ../../..; }
uuuu() { cd ../../../..; }
uuuuu() { cd ../../../../..; }
les() { less "$@"; }
le() { zless "$@"; }
c() { cd "$@"; }
cdnewdir() {
    if [ "$#" -eq 1 ]; then
        mkdir "$1" && cd "$1"
    else
        echo One argument required
    fi
};
mvcdnewdir() {
    if [ "$#" -gt 1 ]; then
        mvnewdir "$@" && cd "${!#}"
    else
        echo At least two arguments expected
    fi
};
mvcd() {
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
                fi
            else
                echo More than two arguments and last one is not a directory
            fi
        fi
    else
        echo At least two arguments expected
    fi
}
cd_newest_sisterfolder() {
    cd "`find .. -maxdepth 1 -type d -print0 |grep -zZ -v '^\.*$'|xargs -0 -s 129023 -n 129023 --exit --no-run-if-empty ls -dt|head -1`"
}
cd_newest() {
    cd "`find . -maxdepth 1 -type d -print0|grep -zZ -v '^\.*$'|xargs -0 -s 129023 -n 129023 --exit --no-run-if-empty ls -dt|head -1`"
}
cdt() {
    if checkcreate-tmp-owner-dir; then
	cd "/tmp/$USER"
    fi
}
cdpwd() {
    cd "`pwd -P`"
}

unlimit() {
    ulimit -S -v unlimited
}

cs() {
    cd ~/scratch
}

find() { my.find "$@"; }
df() { my.df "$@"; }

mv() { command mv -i "$@"; }
cp() { command cp -i "$@"; }
#rm() { command rm -i "$@"; }

rens () {
    cd scratch/
    ren -- "`lastfile .`"
}

settitle () {
    unset PROMPT_COMMAND
    /opt/chj/bin/settitle "$@"
}

if [ "$UID" -eq 0 ]; then
    tar () {
	echo "'tar': use tar-names or tar-numbers instead" >&2
	return 1
    }
fi


# --- End -------------------------------------
if [ -f ~/.bashrc_local ]; then
    source ~/.bashrc_local
fi
