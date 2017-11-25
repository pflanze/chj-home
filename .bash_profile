# ~/.bash_profile: executed by bash(1) for login shells.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.


# use path as given in HOME as PWD [if we're in home] to avoid
# symlinked paths to be shown
if [ "`readlink -f "$PWD"`" = "`readlink -f "$HOME"`" ]; then
    PWD=$HOME
fi

# the default umask is set in /etc/login.defs
# umask 002

# include .bashrc if it exists
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

PATH=/opt/chj/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games

# set PATH so it includes user's private bin if it exists
if [ -d ~/bin ] ; then
    PATH=~/bin:"${PATH}"
fi

# third party software (binaries) installed under the user's home, 'locally'
if [ -d ~/local/bin ] ; then
    PATH=~/local/bin:"${PATH}"
fi

ulimit -S -v 1200000

export EDITOR=e
export BROWSER="chromium-chrissbx -- --new-window"

export EMAIL='ch@christianjaeger.ch'

unset LESSOPEN
unset LESSCLOSE

export LANG=en_GB.UTF-8
