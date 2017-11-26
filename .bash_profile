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

PATH=/opt/chj/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games

# set PATH so it includes user's private bin if it exists
if [ -d ~/bin ] ; then
    PATH=~/bin:"${PATH}"
fi

# third party software (binaries) installed under the user's home, 'locally'
if [ -d ~/local/bin ] ; then
    PATH=~/local/bin:"${PATH}"
fi

if [ "$UID" -eq 0 ]; then
    PATH=/root/local/sbin:/root/sbin:"$PATH"
fi

# --- General env setup -------
unset LESSOPEN
unset LESSCLOSE
# not running Gnome anymore, for some reason this env var is set, why
# no idea, XX.
unset GNOME_KEYRING_CONTROL
export COLUMNS
export HISTSIZE=1500

ulimit -S -v 1200000  # note: can override in .bash_profile_local


# --- Personal env setup: -------
export EDITOR=e
export BROWSER="chromium-chrissbx -- --new-window"
export EMAIL='ch@christianjaeger.ch'
export LANG=en_GB.UTF-8


# --- End -------------------------------------
if [ -f ~/.bash_profile_local ]; then
    source ~/.bash_profile_local
fi
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
