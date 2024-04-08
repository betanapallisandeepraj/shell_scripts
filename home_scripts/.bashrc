# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples


# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
	#PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
	PS1="\[\e[32m\][\D{%H:%M:%S-%d-%m-%Y}]\[\e[0m\]\[\e[34m\]\u@\h:\[\e[0m\]\w$"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#PS1='[\D{%H:%M:%S-%d-%m-%Y}]\u@\h:\w$'

alias ssh_target1="~/ssh_target1.sh"
alias ssh_target2="~/ssh_target2.sh"
alias ssh_target3="~/ssh_target3.sh"
alias ssh_testbed0="~/ssh_testbed0.sh"
alias ssh_testbed1="~/ssh_testbed1.sh"
alias ssh_testbed2="~/ssh_testbed2.sh"
alias ssh_testbed3="~/ssh_testbed3.sh"
alias ssh_testbed4="~/ssh_testbed4.sh"
alias ssh_licensebed="~/ssh_licensebed.sh"
alias ssh_production="~/ssh_production.sh"
alias ssh_beast="~/ssh_beast.sh"
alias ssh_11ax_pc1="~/ssh_11ax_pc1.sh"
alias ssh_11ax_pc2="~/ssh_11ax_pc2.sh"
alias scp_target1="~/scp_target1.sh"
alias scp_target2="~/scp_target2.sh"
alias scp_target3="~/scp_target3.sh"
alias scp_testbed0="~/scp_testbed0.sh"
alias scp_testbed1="~/scp_testbed1.sh"
alias scp_testbed2="~/scp_testbed2.sh"
alias scp_testbed3="~/scp_testbed3.sh"
alias scp_testbed4="~/scp_testbed4.sh"
alias scp_licensebed="~/scp_licensebed.sh"
alias scp_production="~/scp_production.sh"
alias scp_beast="~/scp_beast.sh"
alias scp_11ax_pc1="~/scp_11ax_pc1.sh"
alias scp_11ax_pc2="~/scp_11ax_pc2.sh"
alias scp_both_targets="~/scp_both_targets.sh"
alias goto_lede="cd /mnt/2f085d66-eab7-49a7-9190-206bc3512f78/lede"
alias git_clone="cd /mnt/2f085d66-eab7-49a7-9190-206bc3512f78;git clone git@bitbucket.org:doodlelabs/lede.git"
alias git_clone_luci="cd /mnt/2f085d66-eab7-49a7-9190-206bc3512f78;git clone git@bitbucket.org:doodlelabs/luci.git"
alias say_done="spd-say -t female3 \"Done;Done;Done\""
alias speak_out="~/speak_out.sh"
alias config_build="./config.sh;make -j16;say_done"
alias config_build_tx99="./config.sh -t;make -j16;say_done"
alias config_build_release="./config.sh -r;make -j16;say_done"
alias config_build_kernel="./config.sh -k;make -j16;say_done"
alias config_build_all="config_build;config_build_tx99;config_build_release;config_build_kernel"
alias prepare_lede="goto_lede;config_build;ls -lhtr bin/targets/ar71xx/generic/"
alias ping_target1="~/ping_target1.sh"
alias ping_target2="~/ping_target2.sh"
alias ping_target3="~/ping_target3.sh"
alias ping_both_targets="~/ping_both_targets.sh"
alias ping_testbed0="~/ping_testbed0.sh"
alias ping_testbed1="~/ping_testbed1.sh"
alias ping_testbed2="~/ping_testbed2.sh"
alias ping_licensebed="~/ping_licensebed.sh"
alias sysupgrade_target1="~/sysupgrade_target1.sh"
alias sysupgrade_target2="~/sysupgrade_target2.sh"
alias sysupgrade_both_targets="~/sysupgrade_both_targets.sh"
alias sysupgrade_both_targets_and_ping="~/sysupgrade_both_targets_and_ping.sh > /dev/null"
alias sysupgrade_both_targets_with_latest_image_and_ping="~/sysupgrade_both_targets_with_latest_image_and_ping.sh"
alias show_sleep="~/show_sleep.sh"
alias startup_tabs="~/startup_tabs.sh"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/mnt/2f085d66-eab7-49a7-9190-206bc3512f78/anaconda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/mnt/2f085d66-eab7-49a7-9190-206bc3512f78/anaconda/etc/profile.d/conda.sh" ]; then
        . "/mnt/2f085d66-eab7-49a7-9190-206bc3512f78/anaconda/etc/profile.d/conda.sh"
    else
        export PATH="/mnt/2f085d66-eab7-49a7-9190-206bc3512f78/anaconda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

