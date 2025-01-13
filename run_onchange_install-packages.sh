#!/bin/zsh
if [ -d "$ZSH/lib/cli.zsh" ]; then 
  echo "installed" ; 
else 
  echo "not installed" ; 
fi

#if command -v omz > /dev/null ; then
#  echo "Oh My ZSH already exists at path $ZSH, running 'omz update'";
#  #omz update;
#else
#  echo "Oh my ZSH doesnt exist, installing fresh";
#  #chsh -s $(which zsh) && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)";
#fi
