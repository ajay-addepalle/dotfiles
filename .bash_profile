# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs
#GRADLE_HOME=/opt/gradle/gradle-3.3
CHROME_BIN=/usr/share/chromium
RACER_HOME=/home/aadev/.cargo/bin/racer
export RUST_SRC_PATH=/home/aadev/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src
export GOPATH=$HOME/go
PATH=~/.local/bin:~/.npm-global/bin:$RACER_HOME:$PATH

export PATH

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/aadev/.sdkman"
[[ -s "/home/aadev/.sdkman/bin/sdkman-init.sh" ]] && source "/home/aadev/.sdkman/bin/sdkman-init.sh"

