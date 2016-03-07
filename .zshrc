export AWT_TOOLKIT=MToolkit
export EDITOR=vim
export LESS='-RNSi'
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/code/lib
export PAGER=less
export PATH=$PATH:/opt/java/bin/:$HOME/bin:/usr/local/bin
export PERL5LIB=$PERL5LIB:$HOME/code
export VIEWER=less
#export WORDCHARS='*?_[]~=&;!#$%^(){}<>.'
export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:';
# We expect all escape seqs to take less than 10ms
export KEYTIMEOUT=10
export GOROOT=$HOME/go
export PATH=$PATH:$GOROOT/bin

zstyle ':completion:*' completer _expand _complete _ignored
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' file-sort name
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list '' 'r:|[./]=** r:|=**' 'l:|=* r:|=*' 'm:{[:lower:]}={[:upper:]}'
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' verbose true
zstyle :compinstall filename '$HOME/.zshrc'
autoload -Uz compinit
autoload -U history-search-end
compinit

# Options
HISTFILE=$HOME/.histfile
HISTSIZE=10000
SAVEHIST=10000
DIRSTACKSIZE=50

setopt append_history
setopt auto_param_slash
setopt auto_pushd pushdminus pushdsilent pushdtohome pushd_ignore_dups
setopt dvorak
setopt extended_glob
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_verify
setopt ignore_eof
setopt inc_append_history
setopt interactive_comments
setopt list_rows_first
setopt list_types
setopt mark_dirs
setopt multios
setopt no_nomatch
setopt prompt_subst
setopt rc_quotes
setopt re_match_pcre
setopt short_loops

# Let C-Q/C-S go through
stty stop undef
stty start undef

# functions
function xd() { s=`$HOME/bin/xd $@` && eval cd $s }
function rcd() { s=`$HOME/bin/xd -l -F ~/bin/mru-cd $@` && eval cd $s }
function gx() { s=`$HOME/bin/xd -fl $@` && gvim --remote-silent "$s" }
function catx() { s=`$HOME/bin/xd -fl $@` && cat "$s" }
function git_diff() { git diff --no-ext-diff --color -w "$@" | /bin/less }
function j() { s=`$HOME/bin/xd -F "$HOME/.directories" -l $@` && eval cd $s }

# xd tab complete
# function _whoson { reply=(`$HOME/bin/xd -fp $@`); }
# compctl -U -K _whoson -x 'S[/home]' -f -- talks

# Prompt
VIMODE=' '
function zle-keymap-select {
    VIMODE="${${KEYMAP/vicmd/▶}/(main|viins)/ }"
    zle reset-prompt
}
zle -N zle-keymap-select

function precmd {
	local TERMWIDTH
	(( TERMWIDTH = ${COLUMNS} - 1 ))
	# Truncate the path if it's too long.
	PR_FILLBAR=""
	local promptsize=${#${(%):-(%n@%m %!)---(%D{%a %m/%d/%y %I:%M%p})}}
	PR_FILLBAR="\${(l.(($TERMWIDTH - ($promptsize)))..${PR_HBAR}.)}"
	# Set the urxvt title
	$HOME/bin/xd -a "$PWD" -F "$HOME/.directories" &> /dev/null
	printf "\033]0;%s - URXVT\007" ${PWD/$HOME/\~}
	VIMODE=' '
}
preexec () {
	printf "\033]0;%s\007" $1
}

setprompt () {
	autoload -U colors
	colors
	for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
		eval PR_$color='%{$fg_bold[${(L)color}]%}'
	done
	PR_NO_COLOUR="%{$reset_color%}"
	PR_HBAR='─'
	PROMPT='$PR_BLUE($PR_CYAN%(!.%SROOT%s.%n)@%m$PR_BLUE)$PR_HBAR$PR_CYAN$PR_HBAR${(e)PR_FILLBAR}$PR_BLUE$PR_HBAR($PR_YELLOW%D{%a %m/%d/%y %I:%M%p}$PR_BLUE)
$PR_BLUE%(!.#.()%(?..$PR_MAGENTA%?$PR_BLUE:)$PR_YELLOW%~$PR_BLUE%(!.#.))$PR_CYAN${VIMODE}$PR_NO_COLOUR'
	PS2='$PR_CYAN$PR_HBAR$PR_BLUE$PR_HBAR($PR_LIGHT_GREEN%_$PR_BLUE)$PR_HBAR$PR_CYAN$PR_HBAR$PR_NO_COLOUR '
}

setprompt

# bindkeys [http://www.cs.elte.hu/zsh-manual/zsh_14.html]
autoload zkbd
autoload edit-command-line
zle -N edit-command-line
function zkbd_file() {
	[[ -f ~/.zkbd/${TERM}-${VENDOR}-${OSTYPE} ]] && printf '%s' ~/".zkbd/${TERM}-${VENDOR}-${OSTYPE}" && return 0
	[[ -f ~/.zkbd/${TERM}-${DISPLAY}          ]] && printf '%s' ~/".zkbd/${TERM}-${DISPLAY}"          && return 0
	return 1
}
[[ ! -d ~/.zkbd ]] && mkdir ~/.zkbd
keyfile=$(zkbd_file)
ret=$?
if [[ ${ret} -ne 0 ]]; then
	zkbd
	keyfile=$(zkbd_file)
	ret=$?
fi
if [[ ${ret} -eq 0 ]] ; then
	source "${keyfile}"
else
	printf 'Failed to setup keys using zkbd.\n'
fi
unfunction zkbd_file; unset keyfile ret

zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

bindkey -v
[[ -n "${key[Home]}" ]]       && bindkey  "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}" ]]        && bindkey  "${key[End]}"        end-of-line
[[ -n "${key[Delete]}" ]]     && bindkey  "${key[Delete]}"     delete-char
[[ -n "${key[Backspace]}" ]]  && bindkey  "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Up]}" ]]         && bindkey  "${key[Up]}"         up-line-or-history
[[ -n "${key[Down]}" ]]       && bindkey  "${key[Down]}"       down-line-or-history
[[ -n "${key[Left]}" ]]       && bindkey  "${key[Left]}"       backward-char
[[ -n "${key[Right]}" ]]      && bindkey  "${key[Right]}"      forward-char
[[ -n "${key[PageUp]}" ]]     && bindkey  "${key[PageUp]}"     history-beginning-search-backward-end
[[ -n "${key[PageDown]}" ]]   && bindkey  "${key[PageDown]}"   history-beginning-search-forward-end
bindkey          '^r'   history-incremental-pattern-search-backward
bindkey          '^s'   history-incremental-pattern-search-forward
bindkey          "^P"   vi-up-line-or-history
bindkey          "^N"   vi-down-line-or-history
bindkey -M vicmd 'gg'   beginning-of-history
bindkey -M vicmd 'G'    end-of-history
bindkey -M viins '^a'   vi-beginning-of-line
bindkey -M viins '^e'   end-of-line
bindkey -M viins '^u'   backward-kill-line
bindkey -M vicmd '/'    history-incremental-pattern-search-backward
bindkey -M vicmd '?'    history-incremental-pattern-search-forward
bindkey "\e[1;5D"       vi-backward-blank-word
bindkey "\e[1;5C"       vi-forward-blank-word
bindkey '^xe'           edit-command-line
bindkey -M viins '\eh'  run-help
bindkey "^j"            self-insert
bindkey '^Q'            push-line-or-edit
bindkey '^G'            get-line
bindkey ' '             magic-space
bindkey -s "\eh"         '*.{cc,h}'
bindkey -s "\ej"         '*.java'
bindkey -s "\el"         '*.lisp'
# TODO make C-S-W delete WORD

# Aliases
alias clipboard='xsel -ibp'
alias dh='dirs -v'
alias 'cd..'='cd ..'
alias 'abookq'='abook --mutt-query'
alias 'g'='gvim --remote-silent'
alias sudo='sudo -E'
alias vim='vim -u $HOME/.vimrc -N -U NONE'
alias gvim='gvim -u $HOME/.vimrc -N -U NONE'
alias vimenc='vim -x -u $HOME/.vimrc_enc -N -U NONE'
alias gvimenc='gvim -x -u $HOME/.vimrc_enc -N -U NONE'
alias vless='/usr/share/vim/vim73/macros/less.sh -M'
alias ls='ls --color=always'
alias ll="ls -lh --color=always"
alias lr='ls -tr --color=always'
alias la="ls -a --color=always"
alias grep='grep -Pn --color=always'
#alias less="less -RNSi"
alias ack='ack-grep --color-match=red'
alias ackc='ack-grep --color-match=red --cpp --cc'
alias ackj='ack-grep --color-match=red --java'
alias mplayer='mplayer -vo x11 -zoom'
alias tmux='tmux -2'
alias strings='strings -a'

alias -g L='|&less'
alias -g G='|&grep'
alias -g C='|&xsel -ibp'
alias -g O="|&sed $'s/^E/\e[31mE/; s/^W/\e[33mW/; s/$/\e[m/;'"
