[[ $- != *i* ]] && return

# -- 起動時の表示 --
figlet -c "Hello Kento" | lolcat 
fastfetch

# -- パス設定 --
export PATH="$HOME/go/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"

# -- エディタの設定 --
export EDITOR='nvim'
export VISUAL='nvim'

# -- 自作関数の読み込み --
if [ -f ~/.zsh_functions ]; then
  source ~/.zsh_functions
fi

# -- プロンプト設定 --
if [ -f ~/.zsh_prompt ]; then
  source ~/.zsh_prompt
fi

# -- プラグイン設定の読み込み --
if [ -f ~/.zsh_plugins ]; then
  source ~/.zsh_plugins
fi

# -- エイリアス設定 --
abbr add -f vim='nvim' > /dev/null 2>&1
abbr add -f vi='nvim' > /dev/null 2>&1
abbr add -f cd='z' > /dev/null 2>&1

command -v brew >/dev/null 2>&1 && export PATH="$(brew --prefix)/bin:$PATH"

export PATH="$HOME/.nix-profile/bin:$PATH"
export PATH="/run/current-system/sw/bin:$PATH"

# -- claude code --
export PATH="$HOME/.local/bin:$PATH"

