# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Zinit setup
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Load Powerlevel10k theme
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Load plugins efficiently with simple defer
zinit wait lucid for \
    atinit"zicompinit; zicdreplay" \
        zdharma-continuum/fast-syntax-highlighting \
    atload"_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions \
        zsh-users/zsh-completions \
        Aloxaf/fzf-tab

# Load OMZ snippets (minimal set)
zinit wait lucid for \
    OMZP::sudo \
    OMZP::command-not-found

# History configuration
HISTSIZE=500000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
setopt appendhistory sharehistory hist_ignore_space hist_ignore_all_dups hist_save_no_dups hist_ignore_dups hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Environment variables
export PATH="$HOME/.pyenv/bin:/opt/cuda/bin:$PATH"
export LD_LIBRARY_PATH="/opt/cuda/lib64:$LD_LIBRARY_PATH"
export NVM_DIR="$HOME/.config/nvm"

# Simple lazy loading (optimal balance)
nvm() {
    unset -f nvm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    nvm "$@"
}

# Initialize pyenv on shell startup
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"


# Simple zoxide initialization
eval "$(zoxide init --cmd cd zsh)"

# Load additional completions
fpath+=~/.zfunc

# Load Powerlevel10k configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Load FZF if installed via package manager (fallback)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Aliases
alias ls='ls --color'
alias vim='nvim'
alias vi='nvim'
alias c='clear'
alias cls='clear'
alias gc='git clone'
alias kate='subl'
alias note='subl'
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh
