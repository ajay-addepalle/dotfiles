# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
source $HOME/bash_completion.d/gradle-completion.bash
source /usr/share/bash-completion/bash_completion
export CLASSPATH=".:$CLASSPATH"

powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
. /home/aadev/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/aadev/.sdkman"
[[ -s "/home/aadev/.sdkman/bin/sdkman-init.sh" ]] && source "/home/aadev/.sdkman/bin/sdkman-init.sh"
if [ -f $HOME/.bash_aliases ]
then
  . $HOME/.bash_aliases
fi
