"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vundle
set nocompatible               " be iMproved
filetype off                   " required!
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'Gundo'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'Yggdroot/indentLine'
Plugin 'derekwyatt/vim-fswitch'
Plugin 'derekwyatt/vim-protodef'
Plugin 'hexHighlight.vim'
Plugin 'increment.vim--Avadhanula'
Plugin 'majutsushi/tagbar'
Plugin 'matchit.zip'
Plugin 'thinca/vim-visualstar'
Plugin 'tpope/vim-eunuch'
Plugin 'tpope/vim-fugitive'

"Plugin 'SirVer/ultisnips'
"Plugin 'Shougo/vimproc.vim'

call vundle#end()            " required
filetype plugin indent on    " required

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Au Mappings
au! BufRead,BufNewFile *.inc,*.ihtml,*.tpl,*.class set filetype=php
au! BufRead,BufNewFile *.html,*.xhtml,*.tmpl set filetype=xhtml
au! BufRead,BufNewFile *.g,*.jburg,*.stg set filetype=antlr
au! BufRead,BufNewFile *.conf set filetype=config
au! BufRead,BufNewFile *.gpt set filetype=gnuplot
au! BufRead,BufNewFile *.todo setlocal ft=todo
au! BufRead,BufNewFile *.todocal setlocal ft=todocal
au! BufRead,BufNewFile *.pl,*.cgi,*.t setlocal ft=perl
au! BufRead,BufNewFile *.tex,*.sty,*.cls setlocal ft=tex
au! BufRead,BufNewFile *.bib setlocal ft=bib
au! BufRead,BufNewFile *.c,*.cxx,*.cpp,*.h,*.hpp,*.c++ setlocal ft=cpp
au! BufRead,BufNewFile *.m,*.oct setlocal ft=octave
au! BufRead,BufNewFile *.wiki setlocal ft=qwiki
au! BufRead,BufNewFile *.pb.cfg,*.proto setlocal ft=proto
au! BufRead,BufNewFile *.go setlocal ft=go
au! BufRead,BufNewFile *.acl setlocal ft=acl

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Skelatons
autocmd BufNewFile Makefile r ~/.vim/skelatons/Makefile | normal! ggdd
autocmd BufNewFile *.java r ~/.vim/skelatons/java | normal! ggdd
autocmd BufNewFile *.h r ~/.vim/skelatons/h | normal! ggdd

" Customizing my comment togglings
let b:Comment='#' | let b:EndComment=''
augroup vimrc_filetype
	autocmd!
	"au FileType * let b:Comment='#' | let b:EndComment=''
	au FileType html,php let b:Comment="<!-- " | let b:EndComment=" -->"
	au FileType vim let b:Comment="\"" | let b:EndComment=""
	au FileType sh,zsh,bash,screen,perl,python,tcl,r,config,gnuplot,todo let b:Comment="#" | let b:EndComment=""
	au FileType c,cpp,xs,javascript,java,antlr,go let b:Comment="//" | let b:EndComment=""
	au FileType tex,octave let b:Comment="%" | let b:EndComment=""
	au FileType haskell,lua let b:Comment="--" | let b:EndComment=""
	au FileType lisp let b:Comment=";" | let b:EndComment=""
augroup end

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
" Fswitch
augroup mycppfiles
	au!
	au BufEnter *.h let b:fswitchdst='cpp,cc,c' | let b:fswitchlocs='.'
	au BufEnter *.c,*.cc let b:fswitchdst='h' | let b:fswitchlocs='.'
augroup END

" Protodef
let g:protodefusetemplate=1
let g:protodeftemplate="«$1»"
let g:protodefjoin=" "
let g:protodefprotogetter=$HOME . '/.vim/pullproto.pl'

" MultiSearch
let g:MultipleSearchColorSequence='red,blue,green,magenta,cyan,gray,brown'
let g:MultipleSearchTextColorSequence='white,white,black,white,white,white,white'

" Ack
let g:ackprg="ack-grep -H --nocolor --nogroup --column"

" Easymotion
let g:EasyMotion_leader_key = '<Leader>'
let g:EasyMotion_keys="aoeuidhtnspyfgcrlqjkxbmwvz1234567890"

" Tagbar
let g:tagbar_left=1
let g:tagbar_autoclose=1

" Todo
let g:todo_add_comp=0
let g:todo_bin=$HOME . "/bin/dzen-cal"
let g:todo_browser = "google-chrome --user-data-dir=$HOME/.config/google-chrome/testing"

" Project settings
let g:proj_flags="ciLmsStv"
let g:proj_window_width=40
hi QNamePickerAlt guifg=NONE guibg=#303030 ctermfg=NONE ctermbg=238

" vimux settings
let g:VimuxOrientation = "h"

" Indent Line
let g:indentLine_char = '│'
let g:indentLine_first_char = '│'
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_color_gui = '#303030'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basics
source ~/.vim/vimrc_example.vim

"set guifont=DejaVu\ Sans\ Mono\ 16
set guifont=Inconsolata\ Medium\ 22

colorscheme liquidcarbon

let mapleader=","
let maplocalleader=","

" TODO what was this from
"let g:tex_indent_items=1
"let g:xml_use_xhtml=1
"let g:html_number_lines=1
"let g:use_xhtml=1
"let g:html_use_css=1

if &term =~ '^\(xterm\|screen\|screen-256color\|rxvt\|rxvt-unicode\)' " && $COLORTERM == 'gnome-terminal'
	set t_Co=256
endif
