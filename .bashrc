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

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if [ -f /etc/bash_completion ]; then
#    . /etc/bash_completion
#fi


alias u="cd .."
alias uu="cd ../.."
alias uuu="cd ../../.."
alias uuuu="cd ../../../.."
alias uuuuu="cd ../../../../.."
#alias cdnewdir="
alias les=less
alias le=zless
#^ zless?  egal ja ebe ?. nun. -- nope nid egal. cat file.gz|less doesn't work, zless does.
alias c=cd
alias cdsp="cd ~/Projekte/spielzeug"
cdnewdir() {
    if [ "$#" -eq 1 ]; then
        mkdir "$1" && cd "$1"
    else
        echo One argument required
    fi
};
mvcdnewdir() {
    if [ "$#" -gt 1 ]; then
        mvnewdir "$@" && cd "${!#}"   # ${!#}: Tip 16Nov02 1544 von #bash
    else
        echo At least two arguments expected
    fi
};
mvcd() {
    if [ "$#" -gt 1 ]; then
        if [ -d "${!#}" ]; then
            mv "$@" && cd "${!#}"
        else
            #echo Last argument is not a directory
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
# ich benutz doch (wieder?) oefter cdp (Buchsi schwimmbad)
cdp() {
    cd "`pwd -P`"
}
export COLUMNS

HISTSIZE=1500

unlimit() {
    ulimit -S -v unlimited
}

cs() {
    cd ~/scratch
}
ct () {
    cd ~/Projekte/thesis
}

alias find=my.find
alias df=my.df

alias mv='mv -i'
alias cp='cp -i'
#alias rm='rm -i'

alias cdth=ct
alias cdc='cd ~/Projekte/categorical'

rens () {
    cd scratch/
    ren -- "`lastfile .`"
}

# hm hack for novo, not running Gnome anymore, for some reason this
# env var is set, why no idea, foo.
unset GNOME_KEYRING_CONTROL

settitle () {
    unset PROMPT_COMMAND
    /opt/chj/bin/settitle "$@"
}


export ALSARECDEV='sysdefault:CARD=C1100'

newAI () {
    cd ~/Github/LondonHackspaceAI-common
    cat <<EOF >> users/Christian.md
* []() ([HN]())

EOF
    E users/Christian.md
}

newRust () {
    cd ~/Github/LondonRustLearners-wiki
    cat <<EOF >> users/Christian_Jaeger.md
* []() ([HN]())

EOF
    E users/Christian_Jaeger.md
}

export LANG=en_GB.UTF-8
