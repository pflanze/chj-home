# ~/.bash_profile: executed by bash(1) for login shells.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# Set $USER if not already set (this is necessary when starting the
# desktop via crontab (VNC server).)
export USER=${USER-$(/opt/chj/bin/user "$UID")}

# use path as given in HOME as PWD [if we're in home] to avoid
# symlinked paths to be shown
if [ "`readlink -f "$PWD"`" = "`readlink -f "$HOME"`" ]; then
    PWD=$HOME
fi

# $HOSTNAME is apparently magical (apparently reading from the
# kernel), thus use another env var to keep actual hostname
# definition, for chroots:
export CHJHOSTNAME="$(head -1 /etc/hostname)"

# the default umask is set in /etc/login.defs
# umask 002

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/opt/chj/bin:/opt/chj/cj-git-patchtool:/opt/chj/git-sign/bin:/opt/chj/chjize/bin

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
export LESS="-i -M -R"

# not running Gnome anymore, for some reason this env var is set, why
# no idea, XX.
unset GNOME_KEYRING_CONTROL
export COLUMNS
export HISTCONTROL=ignoredups
export HISTSIZE=5000

ulimit -S -v 3200000  # note: can override in .bash_profile_local

if [ -n "${DISPLAY-}" ]; then
    xset -b
fi

# cj's key (since you're trusting his repo already, why not also trust
# his key?)
export VERIFY_SIG_ACCEPT_KEYS=A54A1D7CA1F94C866AC81A1F0FA5B21104EDB072


# --- Personal env setup: -------
if [ -f ~/.bash_profile_local ]; then
    source ~/.bash_profile_local
else
    echo "NOTE: ~/.bash_profile_local does not exist, please run ~/.chj-home/init" >&2
fi
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
