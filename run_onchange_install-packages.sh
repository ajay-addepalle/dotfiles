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

#ZSH Plugins
rm -rf "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting 

rm -rf "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions

rm -rf "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/fzf-tab
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab

# skeytchybar lua 
(git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua && cd /tmp/SbarLua/ && make install && rm -rf /tmp/SbarLua/)
