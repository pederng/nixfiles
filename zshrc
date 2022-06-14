HISTFILE=$XDG_DATA_HOME/zsh/histfile
HISTSIZE=100000
SAVEHIST=10000

setopt incappendhistory autocd extendedglob
unsetopt beep nomatch notify
bindkey -v

setopt prompt_subst

zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename "$ZDOTDIR/.zshrc"


fpath=($ZDOTDIR/completions $fpath)
fpath=($ZDOTDIR/zfunc $fpath)
autoload -Uz compinit
compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION

autoload -U bashcompinit
bashcompinit

setopt NO_HUP

# Disable c-s hanging of terminal
stty -ixon

# Tab completion for cd ..

zstyle ':completion:*' special-dirs true

# Bindings

bindkey '^p' up-history
bindkey '^n' down-history
bindkey '^?' backward-delete-char
bindkey '^d' delete-char
bindkey '^[d' delete-word
# bindkey '^h' backward-delete-char
# bindkey '^k' kill-line
# bindkey '^j' accept-line
# bindkey '^l' clear-screen
bindkey '^y' yank
bindkey '^w' backward-kill-word
bindkey '^b' backward-char
bindkey '^[b' backward-word
bindkey '^f' forward-char
bindkey '^[f' forward-word
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

# Nix
test -f ~/.nix-profile/etc/profile.d/nix.sh &&  . ~/.nix-profile/etc/profile.d/nix.sh

#Prompt
eval "$(starship init zsh)"

# Visual mode fixes
export KEYTIMEOUT=1

zshrc=$ZDOTDIR/.zshrc
#Configurations
conf() {
    case $1 in
        pacman)      svim /etc/pacman.conf ;;
        tmux)        nvim $XDG_CONFIG_HOME/tmux/tmux.conf ;;
        mutt)        nvim $XDG_CONFIG_HOME/mutt/muttrc ;;
        vim)         vim $XDG_CONFIG_HOME/vim/vimrc ;;
        nvim)        nvim $XDG_CONFIG_HOME/nvim/init.lua ;;
        emacs)       emacs -nw $XDG_CONFIG_HOME/emacs/init.el ;;
        vim-local)   nvim $XDG_CONFIG_HOME/vim/machine_specific_vimrc ;;
        zathura)     nvim $XDG_CONFIG_HOME/zathura/zathurarc ;;
        zsh)         nvim $zshrc && source $zshrc ;;
        zprofile)    nvim $ZDOTDIR/.zprofile ;;
        zsh-local)   nvim $ZDOTDIR/machine_specific && source $zshrc ;;
        aliases)     nvim $ZDOTDIR/aliases && source $zshrc ;;
        functions)   nvim $ZDOTDIR/functions && source $zshrc ;;
        git)         nvim $XDG_CONFIG_HOME/git/config ;;
        qutebrowser) nvim $XDG_CONFIG_HOME/qutebrowser/config.py ;;
        ssh)         nvim ~/.ssh/config ;;
        starship)    nvim $XDG_CONFIG_HOME/starship.toml ;;
        xresources)  nvim $XDG_CONFIG_HOME/X11/xresources && xrdb -merge $XDG_CONFIG_HOME/X11/xresources && xrdb -merge $XDG_CONFIG_HOME/X11/xcolors;;
        xinit)       nvim $XDG_CONFIG_HOME/X11/xinitrc;;
        nix)         nvim $XDG_CONFIG_HOME/nixpkgs/home.nix;;
        *)           echo "Unknown application: $1" ;;
    esac
}

function _complete_conf {
  reply=('functions' 'aliases' 'zsh' 'zprofile' 'zsh-local' 'vim' 'emacs' 'vim-local' 'mutt' 'qutebrowser' 'tmux' 'ssh' 'starship' 'xresources' 'xinit' 'nvim' 'nix')
}
compctl -K _complete_conf conf


# Python virtualenv
export WORKON_HOME=$XDG_DATA_HOME/virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python
source ~/.local/bin/virtualenvwrapper.sh

# Base16 Shell
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
export BASE16_SHELL_HOOKS=$XDG_CONFIG_HOME/base16-hooks


#Syntax highlighting
if [ ! -f $ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZDOTDIR/zsh-syntax-highlighting
fi
source $ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zsh-histdb
if [ ! -f $ZDOTDIR/zsh-histdb/sqlite-history.zsh ]; then
  git clone https://github.com/larkery/zsh-histdb $ZDOTDIR/zsh-histdb
fi
source $ZDOTDIR/zsh-histdb/sqlite-history.zsh
autoload -Uz add-zsh-hook

# forgit
if [ ! -f $ZDOTDIR/forgit/forgit.plugin.zsh ]; then
  git clone https://github.com/wfxr/forgit $ZDOTDIR/forgit/
fi
source $ZDOTDIR/forgit/forgit.plugin.zsh

# Jumping
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"


# Fuzzy completion
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh
export FZF_DEFAULT_OPTS="--multi"
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
bindkey '^I' $fzf_default_completion

if [ ! -f $ZDOTDIR/zsh-histdb-fzf/fzf-histdb.zsh ]; then
  git clone https://github.com/m42e/zsh-histdb-fzf $ZDOTDIR/zsh-histdb-fzf
fi
export HISTDB_FZF_DEFAULT_MODE=3
source $ZDOTDIR/zsh-histdb-fzf/fzf-histdb.zsh

# Vim mode improvements
export KEYTIMEOUT=10
bindkey -M viins 'jk' vi-cmd-mode


function _pip_completion {
  local words cword
  read -Ac words
  read -cn cword
  reply=( $( COMP_WORDS="$words[*]" \
             COMP_CWORD=$(( cword-1 )) \
             PIP_AUTO_COMPLETE=1 $words[1] ) )
}
compctl -K _pip_completion pip

# Notes
export NOTES_DIR=$XDG_DATA_HOME/notes
export ZETTEL_DIR=$NOTES_DIR/zettelkasten

# pipenv completion
command -v pipenv >/dev/null && eval "$(_PIPENV_COMPLETE=zsh_source pipenv)"

# Stack completion
command -v stack >/dev/null && eval "$(stack --bash-completion-script stack)"

eval "$(journal completion)"
eval "$(zettel completion)"

function preexec() {
    _tmux_update_env
    _update_agents
}

DO_NOT_TRACK=1


#----Machine-specific----
source $ZDOTDIR/machine_specific
