" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
	finish
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible                        " Use vim not vi
set backspace=indent,eol,start          " allow backspacing over everything in insert mode
set whichwrap=<,>,[,],h,l               " make left/right/h/l move over the line endings
set nobackup                            " do not keep a backup file, use versions instead
set history=50                          " keep 50 lines of command line history
set ruler                               " show the cursor position all the time
set showcmd                             " display incomplete commands
set number relativenumber               " Show distance from cursor
set conceallevel=2                      " Enable full conceal support
set cryptmethod=blowfish                " Use a real cipher for encryption
set nowrap                              " turn off line wrapping
set incsearch                           " do incremental searching
set gdefault                            " Make substitutions replace all
set hidden                              " Allow switching tabs w/o saving
set autochdir                           " Auto switch to the current buffer dierctory
set foldcolumn=0                        " How many characters wide is the fold margin
set foldmethod=indent                   " How should it decide to fold
set foldlevel=256                       " Start with no folds
set ignorecase                          " Searches should ignore case
set smartcase                           " Use smart case, e.g. asdf is case-insensitive but Asdf is case-sensitive
set autowriteall                        " Save file whenever focus is lost
set showtabline=1                       " show tabs when necessary
set grepprg=grep\ $*\ -Pn\ -R\ .        " Make :grep use pcregrep and recurse
set dictionary=~/.vim/dicts/words.txt   " use this dictionary for complete
set thesaurus=~/.vim/dicts/mthesaur.txt " for thesaurus <C-X><C-T>
set complete=.,w,b                      " the current buffer, other windows, and loaded buffers
set omnifunc=                           " Don't know why this is what I want...
set tabline=%!MyTabLine()               " Customize the tabline
set formatoptions=crqv                  " wrap comments, append the comment leader, and allow gq to format comments, CR in comments does not create a comment leader
set tabstop=8                           " Set up vim to use only tabs and have a tabstop of 8
set shiftwidth=8                        " Keep shifting to keep tabs
set noexpandtab                         " Keep my tabs
set tildeop                             " use tilde as an operator
set guioptions=c                        " show console popups
set mouse=a                             " Always use the mouse
set wildmode=longest:full               " Complete to the longest prefix match and prompt with wildmenu with the options
set wildmenu                            " Very nice little menu when using commands that work with file, <Left>/<Right> change file, <Up>=.., <Down> goes into director, <Enter> opens
set smartindent                         " always set autoindenting on
set shortmess=atI                       " Shorten messages to avoid Press Any Key
set wildignore+=*.exe,*.dll,*.pdf,*.ps,*.obj,*.pdb,*.vcproj,*.aux,*.bbl " Ignore these extensions
set matchpairs=(:),[:],{:}              " Set the characters for matching
set laststatus=2                        " Always show the statusline
set lcs=eol:\ ,trail:Â·,tab:â”‚\  " Make the list characters show properly
set list                                " Display the eol, trailing spaces, and tabs
set nostartofline                       " Keep the column when paging
set mousemodel=popup                    " Right mouse button shows a popup menu
set mousehide                           " Don't display the mouse when typing
set selection=exclusive                 " Don't include the last character in selections
set selectmode=                         " Never start select mode
set keymodel=startsel                   " Shifted special keys start selection
set textwidth=0                         " Don't set the textwidth
set switchbuf=useopen,usetab,split      " Make switching use an open window
set grepprg=ack-grep\ -H\ --nocolor\ --nogroup\ --column
set grepformat=%f:%l:%m
" Customize the status line, display the buffer number, filename, flags, format, type, value under curs, and pos
set statusline=%n\ %<%0.60f%([%M%R%H%W]%)\ %=\ %28(%{&ff=='unix'?'u':&ff=='mac'?'m':'w'}\ %y\ [%3b\ 0x%-2B]\ %c\ %l/%L%)

if has("persistent_undo")
	set undofile		" save the undo history
endif

let mapleader=","
let maplocalleader=","

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
	syntax on
	set hlsearch
endif

" turn on filetype plugins and indenting
filetype plugin indent on

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
	\ if line("'\"") > 0 && line("'\"") <= line("$") |
	\   exe "normal! g`\"" |
	\ endif

" Fugitive additions
autocmd User fugitive 
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif
" Delete fugitive buffers on exit
autocmd BufReadPost fugitive://* set bufhidden=delete

" Default for TOhtml
let html_number_lines = 1
let use_xhtml = 1
let html_use_css = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings

noremap ;; ;
map ; :
cmap <C-A> <Home>
nmap <M-6> :FSHere<CR>
" M-6 in a term sends ESC
nmap <ESC>6 :FSHere<CR>

" Tags
nmap g[ :pop<CR>
nmap <silent> <F3> :TagbarToggle<CR>
nmap <silent> <Leader>3 :TagbarToggle<CR>
imap <silent> <F3> <ESC>:TagbarToggle<CR>

" edit command-line
map q; q:

" formatting
map Q gq

" Deletes
vnoremap <silent> <BS> "_d
vnoremap <silent> <DEL> "_d
nnoremap <silent> <leader>d "_d
vnoremap <silent> <leader>d "_d
nnoremap <silent> <leader>x "_x
vnoremap <silent> <leader>x "_x
nnoremap <silent> <leader>c "_c
vnoremap <silent> <leader>c "_c

" Cut/Copy
vnoremap <silent> <C-X> "+x
vnoremap <silent> <S-Del> "+x
vnoremap <silent> <C-C> "+y
vnoremap <silent> <C-Insert> "+y

" Paste
"map <silent> <C-V> "+gP
exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
exe 'vnoremap <script> <C-V>' paste#paste_cmd['v']
cmap <silent> <C-V> <C-R>+
map <silent> <S-INSERT> "+gP
cmap <silent> <S-INSERT> <C-R>+
exe 'inoremap <script> <S-INSERT>' paste#paste_cmd['i']
exe 'vnoremap <script> <S-INSERT>' paste#paste_cmd['v']

" Undo/redo
noremap <silent> <C-Z> u
inoremap <silent> <C-Z> <ESC>ua

" Select all
inoremap <silent> <C-A> <C-O>gg<C-O>gH<C-O>G
vnoremap <silent> <C-A> <C-C>gggH<C-O>G

" Increment/decrement
nmap <silent> + <C-A>
nmap <silent> _ <C-X>

" Searching
map <silent> <M-/> :nohlsearch<CR>
imap <silent> <M-/> <ESC>:nohlsearch<CR>a
nmap <silent> n nzz
nmap <silent> N Nzz
nmap <silent> * *zz
nmap <silent> # #zz
nmap <silent> g* g*zz
nmap <silent> g# g#zz

" Buffers
nmap <silent> <F2> :buffers<CR>:buffer<SPACE>
map <silent> <C-TAB> :bn<CR>
imap <silent> <C-TAB> <ESC>:bn<CR>
map <silent> <C-S-TAB> :bp<CR>
imap <silent> <C-S-TAB> <ESC>:bp<CR>

" Windows
noremap <silent> <C-h> <C-w>h
noremap <silent> <C-j> <C-w>j
noremap <silent> <C-k> <C-w>k
noremap <silent> <C-l> <C-w>l
noremap <silent> <C-p> <C-w>p
noremap <silent> <C-Space> <C-w>p
noremap <silent> <C-W>1 <C-W>1<C-W>
noremap <silent> <C-W>2 <C-W>2<C-W>
noremap <silent> <C-W>3 <C-W>3<C-W>
noremap <silent> <C-W>4 <C-W>4<C-W>
noremap <silent> <C-W>5 <C-W>5<C-W>
noremap <silent> <C-W>6 <C-W>6<C-W>
noremap <silent> <C-W>7 <C-W>7<C-W>
noremap <silent> <C-W>8 <C-W>8<C-W>
noremap <silent> <C-W>9 <C-W>9<C-W>
noremap <silent> <M-C-h> <C-w><
noremap <silent> <M-C-j> <C-w>+
noremap <silent> <M-C-k> <C-w>-
noremap <silent> <M-C-l> <C-w>>
noremap <silent> <M-s> <C-w>s
noremap <silent> <M-v> <C-w>v
noremap <silent> <M-S-v> :vertical botright split<CR>
noremap <silent> <M-S-s> :topleft split<CR>
noremap <silent> <M-n> <C-w><C-w>
noremap <silent> <M-p> <C-w><S-w>
noremap <silent> <M-S-h> <C-W>H
noremap <silent> <M-S-j> <C-W>J
noremap <silent> <M-S-k> <C-W>K
noremap <silent> <M-S-l> <C-W>L
nnoremap <silent> <M-c> <C-W>c
nnoremap <silent> <M-o> <C-W>o
nnoremap <silent> <M-=> <C-W>100+
nnoremap <silent> <M--> <C-W>100-
map <silent> <M-\> :call <SID>WindowToggle(1)<CR>

" Tab motion
map <silent> <F10> :tabn<CR>
imap <silent> <F10> <ESC>:tabn<CR>
map <silent> <F9> :tabp<CR>
imap <silent> <F9> <ESC>:tabp<CR>

imap <M-<> «
imap <M->> »

nmap <silent> <F8> :setl sw=2 \| setl ts=2 \| setl et<CR>
nmap <silent> <Leader>8 :setl sw=2 \| setl ts=2 \| setl et<CR>

" Tab movement
map <F11> :<C-U>call <SID>MoveTab("l", v:count)<CR>
imap <F11> <ESC>:<C-U>call <SID>MoveTab("l", v:count)<CR>
map <F12> :<C-U>call <SID>MoveTab("r", v:count)<CR>
imap <F12> <ESC>:<C-U>call <SID>MoveTab("r", v:count)<CR>

" New buffer
nmap <silent> <C-N> :new<CR>

" Saving
noremap <silent> <C-S> :update<CR>
vnoremap <silent> <C-S> <C-C>:update<CR>
inoremap <silent> <C-S> <C-O>:update<CR>

" Closing
map <silent> <C-F4> :confirm :bd<CR>
imap <silent> <C-F4> <ESC>:confirm :bd<CR>

" Autocomplete
imap <silent> <C-SPACE> <C-R>=<SID>CleverTab(1)<CR>
imap <silent> <C-S-SPACE> <C-R>=<SID>CleverTab(0)<CR>

" Make home/end traverse the wrappings and such properly
map <silent> <HOME> :call <SID>SmartHome("n")<CR>
imap <silent> <HOME> <C-R>=<SID>SmartHome("i")<CR>
vmap <silent> <HOME> <ESC>:call <SID>SmartHome("v")<CR>
map <silent> <END> :call <SID>SmartEnd("n")<CR>
imap <silent> <END> <C-R>=<SID>SmartEnd("i")<CR>
vmap <silent> <END> <ESC>:call <SID>SmartEnd("v")<CR>
sunmap <HOME>
sunmap <END>

" Newlines
"nmap <silent> <CR> o
"nmap <silent> <S-CR> O
"au CmdwinEnter * nunmap <CR>
"au CmdwinLeave * nmap <silent> <CR> o
au BufEnter FileType qf nmap <buffer> <CR> :call NormalNewline()<CR>
au BufEnter FileType help nmap <buffer> <CR> :call NormalNewline()<CR>

function! NormalNewline()
	exe "norm! \<CR>"
endfunction

" Delete all newlines but one
"map <silent> <C-O> ?^\S\+<CR>:s/\n\{2,}/\r\r/e<CR>:nohlsearch<CR>

" Yank to eol
map <silent> Y y$

" Refactoring
vmap \em :call MyExtractMethod()<CR>

" Spelling
map <silent> <F7> :setlocal spell spelllang=en_us<CR>
imap <silent> <F7> <ESC>:setlocal spell spelllang=en_us<CR>
map <silent> <S-F7> :setlocal nospell<CR>
imap <silent> <S-F7> <ESC>:setlocal nospell<CR>

" Opening files in new split
nmap <silent> gf <C-w><C-f>

" Indent/dedent
map <silent> <M-RIGHT> >>
map <silent> <M-LEFT> <<
imap <silent> <M-RIGHT> <ESC>m`>>``la
imap <silent> <M-LEFT> <ESC>m`<<``i
vmap <silent> <M-RIGHT> >
vmap <silent> <M-LEFT> <
nmap <silent> <TAB> >>
nmap <silent> <S-TAB> <<
vmap <silent> <TAB> >
vmap <silent> <S-TAB> <
vmap <silent> > >gv
vmap <silent> < <gv
"imap <silent> <S-TAB> <C-D>

" make control click select word
nmap <silent> <C-LEFTMOUSE> <LEFTMOUSE>viw<C-G>
imap <silent> <C-LEFTMOUSE> <LEFTMOUSE><ESC>viw<C-G>

" Title case
vmap <silent> gT :s/\%V\<\(\w\)\(\w*\)\>/\u\1\L\2/e<CR>:nohlsearch<CR>

noremap <silent> <C-UP> H
inoremap <silent> <C-UP> <ESC>Hi
noremap <silent> <C-DOWN> L
inoremap <silent> <C-DOWN> <ESC>Li
nnoremap <silent> <S-SPACE> <C-B>
nnoremap <silent> <SPACE> <C-F>

" Move lines
nmap <silent> <M-DOWN> :move .+1<CR>
imap <silent> <M-DOWN> <ESC>:move .+1<CR>i
vmap <silent> <M-DOWN> :move '>+1<CR>gv
nmap <silent> <M-UP> :move .-2<CR>
imap <silent> <M-UP> <ESC>:move .-2<CR>
vmap <silent> <M-UP> :move '<-2<CR>gv
nmap <silent> <M-j> :move .+1<CR>
imap <silent> <M-j> <ESC>:move .+1<CR>i
vmap <silent> <M-j> :move '>+1<CR>gv
nmap <silent> <M-k> :move .-2<CR>
imap <silent> <M-k> <ESC>:move .-2<CR>
vmap <silent> <M-k> :move '<-2<CR>gv

" on the terminal I am getting strange sequences for left/right/up/down...
if !has("gui_running")
	nmap <ESC>OA <NOP>
	nmap <ESC>OB <NOP>
	nmap <ESC>OD <NOP>
	nmap <ESC>OC <NOP>
	imap <ESC>OA <NOP>
	imap <ESC>OB <NOP>
	imap <ESC>OD <NOP>
	imap <ESC>OC <NOP>
	"unmap <C-V>
endif
nmap <LEFT> <Nop>
nmap <RIGHT> <Nop>
nmap <UP> <Nop>
nmap <DOWN> <Nop>
imap <LEFT> <Nop>
imap <RIGHT> <Nop>
imap <UP> <Nop>
imap <DOWN> <Nop>

" Commenting
map <silent> <F6> :call <SID>CommentLines()<CR>
map <silent> <Leader>6 :call <SID>CommentLines()<CR>
imap <silent> <F6> <ESC>:call <SID>CommentLines()<CR>i
map <silent> <F5> :call <SID>UncommentLines()<CR>
map <silent> <Leader>5 :call <SID>UncommentLines()<CR>
imap <silent> <F5> <ESC>:call <SID>UncommentLines()<CR>i

" execute the current line and place the output of the shell command on the next line
map <silent> <C-F10> :exec "r !" . getline(".")<CR>
imap <silent> <C-F10> <ESC>:exec "r !" . getline(".")<CR>

nmap <silent> <C-CR> :call <SID>Browser()<CR>

" Project mappings
nmap <silent> <Leader>p <Plug>ToggleProject
nmap <silent> <Leader>a :call LustyProjectFilePicker(0)<cr>:~
nmap <silent> <Leader>A :call LustyProjectFilePicker(1)<cr>:~

" QNameFile mappings
nnoremap [qnamepicker_key] <Nop>
nmap <silent> - [qnamepicker_key]
nmap <unique> <F4> :call QNameBufInit(0, 0, 1, 1)<cr>:~
nmap <unique> <S-F4> :call QNameFileInit('', '', 0)<cr>:~
nmap <unique> [qnamepicker_key]b :call QNameBufInit(0, 0, 1, 1)<cr>:~
" TODO ideally these'd be pulled from qproject
nmap <unique> [qnamepicker_key]F :call QNameFileInit('', '', 0)<cr>:~
nmap <unique> [qnamepicker_key]f :call QNameFileInit('%', '', 0)<cr>:~
nmap <unique> [qnamepicker_key]o :call QNameOutlineInit(0, '', 1)<cr>:~

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Commands

" Force save the file
cmap w!! %!sudo tee > /dev/null %

" Call Perl to calculate an expression
let $PERL5LIB.=$HOME . '/code'
command! -nargs=+ Calc :perl VIM::Msg(<q-args> . ' = ' . `$ENV{HOME}/bin/calc.pl -q <q-args>`)

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis

" Convienient wrapper for renaming files
"command! -nargs=* -complete=file -bang Ren :call <SID>Rename("<args>", "<bang>")

" Convinient helper to get a cound of the number of lines which match a
" regular expression
command! -nargs=1 -range=% -bang Count :let _cline=line('.') | let _ccol=col('.') | <line1>,<line2>call <SID>CountPattern(<q-args>, <bang>0, _cline, _ccol)

" Convinience functions
command! -range UrlEncode <line1>,<line2>call UrlEncode()
command! -range UrlDecode <line1>,<line2>call UrlDecode()

" Quit all
command! -bang Q :qa

" Execute a command in a new window
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Text stuff
augroup batz_text
if !exists("has_batz_text")
	let has_batz_text = 1
	autocmd FileType text setlocal textwidth=80
	autocmd FileType text setlocal formatoptions+=t
endif
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" calc stuff
augroup batz_calc
if !exists("has_batz_calc")
	let has_batz_calc = 1
	autocmd FileType calc map <buffer> <silent> <C-F10> :perl <<EOF<CR>@pos = $curwin->Cursor();<CR>$v = eval $curbuf->Get($pos[0]);<CR>$curbuf->Append($pos[0], "=========================", $v, "", "");<CR>$curwin->Cursor($pos[0]+4, $pos[1]);<CR>EOF<CR>$
	autocmd FileType calc imap <buffer> <silent> <C-F10> <ESC>:perl <<EOF<CR>@pos = $curwin->Cursor();<CR>$v = eval $curbuf->Get($pos[0]);<CR>$curbuf->Append($pos[0], "=========================", $v, "", "");<CR>$curwin->Cursor($pos[0]+4, $pos[1]);<CR>EOF<CR>o
	autocmd FileType calc map <buffer> <silent> <CR> :perl <<EOF<CR>@pos = $curwin->Cursor();<CR>$v = eval $curbuf->Get($pos[0]);<CR>$curbuf->Append($pos[0], "=========================", $v, "", "");<CR>$curwin->Cursor($pos[0]+4, $pos[1]);<CR>EOF<CR>$
	autocmd FileType calc imap <buffer> <silent> <CR> <ESC>:perl <<EOF<CR>@pos = $curwin->Cursor();<CR>$v = eval $curbuf->Get($pos[0]);<CR>$curbuf->Append($pos[0], "=========================", $v, "", "");<CR>$curwin->Cursor($pos[0]+4, $pos[1]);<CR>EOF<CR>o
endif
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" gxp stuff
augroup batz_gxp
	au! BufNewFile,BufRead *.gxp setl ts=2 | setl sw=2 | setl expandtab | set ft=html
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Function definitions
" Get chrome to open a url
function! s:Browser()
	let line = getline(".")
	let line = matchstr(line, "\\%(http://\\|ftp://\\|www\.\\)[^ ,;\t]*")
	exec ':silent !google-chrome ' . "\"" . line . "\""
endfunction

" Tab for autocomplete
function! s:CleverTab(dir)
	if pumvisible()
		if a:dir==1
			return "\<C-N>"
		else
			return "\<C-P>"
		endif
	endif
	if a:dir == 1
		return "\<C-X>\<C-N>"
	else
		return "\<C-X>\<C-K>"
	endif
endfunction

" Make home switch b/t ^ and 0, and handle wrapped lines
function! s:SmartHome(mode)
	let curcol = col(".")
	let curindent = (indent(".") + 1)/&tabstop
	"gravitate towards beginning for wrapped lines
	if curcol > curindent + 1
		call cursor(0, curcol - 1)
	endif
	if curcol == 1 || curcol > curindent + 1
		if &wrap
			normal g^
		else
			normal ^
		endif
	else
		if &wrap
			normal g0
		else
			normal 0
		endif
	endif
	if a:mode == "v"
		normal msgv`s
	endif
	return ""
endfunction 

" Make end handle wrapped lines
function! s:SmartEnd(mode)
	let curcol = col(".")
	let lastcol = a:mode == "i" ? col("$") : col("$") - 1
	"gravitate towards ending for wrapped lines
	if curcol < lastcol - 1
		call cursor(0, curcol + 1)
	endif
	if curcol < lastcol
		if &wrap
			normal g$
		else
			normal $
		endif
	else
		normal g_
	endif
	"correct edit mode cursor position, put after current character
	if a:mode == "i"
		call cursor(0, col(".") + 1)
	endif
	if a:mode == "v"
		normal msgv`s
	endif
	return ""
endfunction 

" Add the Comment defined in the buffer to the beginning of the line
function! s:CommentLines()
	exe ":s@^\\(\\s*\\)@\\1" . b:Comment . "@g"
	exe ":s@$@" . b:EndComment . "@g"
endfunction

" Remove the Comment defined in the buffer from the beginning of the line
function! s:UncommentLines()
	exe ":s@^\\(\\s*\\)" . b:Comment . "@\\1@ge"
	exe ":s@" . b:EndComment . "\\(\\s*\\)$@\\1@ge"
endfunction

" Custom increment command a:c specifies the number of times to increment
function! s:BatzIncrement(c)
	let t = a:c
	if t <= 0
		let t = 1
	endif
	let cmd = "norm! " . t . "\<C-A>"
	exe cmd
	echo cmd
endfunction

" Custom decrement command a:c specifies the number of times to decrement
function! s:BatzDecrement(c)
	let t = a:c
	if t <= 0
		let t = 1
	endif
	let cmd = "norm! " . t . "\<C-X>"
	exe cmd
	echo cmd
endfunction

" Customize the tabline
function! MyTabLine()
	let s = ''
	for i in range(tabpagenr('$'))
		" select the highlighting
		if i + 1 == tabpagenr()
			let s .= '%#TabLineSel#'
		else
			let s .= '%#TabLine#'
		endif
		" set the tab page number (for mouse clicks)
		let s .= '%' . (i + 1) . 'T'
		" the label is made by MyTabLabel()
		let s .= ' %{MyTabLabel(' . (i + 1) . ')} |'
	endfor
	" after the last tab fill with TabLineFill and reset tab page nr
	let s .= '%#TabLineFill#%T'
	" right-align the label to close the current tab page
	if tabpagenr('$') > 1
		let s .= '%=%#TabLine#%999X X'
	endif
	return s
endfunction

" Custom tab label
function! MyTabLabel(n)
	let buflist = tabpagebuflist(a:n)
	let winnr = tabpagewinnr(a:n)
	let numtabs = tabpagenr('$')
	" account for space padding between tabs, and the "close" button
	let maxlen = (&columns - (numtabs * 2) - 4) / numtabs
	let tablabel = bufname(buflist[winnr - 1])
	if tablabel == ''
		let tablabel = "[No Name]"
	endif
	while strlen(tablabel) < 4
		let tablabel = tablabel . " "
	endwhile
	let tablabel = fnamemodify(tablabel, ':t')
	let tablabel = a:n . ' ' . tablabel
	let tablabel = strpart(tablabel, 0, maxlen)
	return tablabel
endfunction

" Rename the current file using a:name (a:bang forces the operation)
"function! s:Rename(name, bang)
	"let l:curfile = expand("%:p")
	"let v:errmsg = ""
	"silent! exe "saveas" . a:bang . " " . a:name
	"if v:errmsg =~# '^$\|^E329'
		"if expand("%:p") !=# l:curfile && filewritable(expand("%:p"))
			"silent exe "bwipe! " . l:curfile
			"if delete(l:curfile)
				"echoerr "Could not delete " . l:curfile
			"endif
		"endif
	"else
		"echoerr v:errmsg
	"endif
"endfunction

" Counts the number of lines which match pattern,
" a:patt what to search for
" a:bang to count lines which don't match a:patt
" a:cline what line to return the cursor to
" a:ccol what column to return the cursor to
function! s:CountPattern(patt, bang, cline, ccol) range
	" TODO make use g//
	let _first = a:firstline
	let _last = a:lastline
	let _count=0
	while _first <= _last
		if (a:bang != 0 && match(getline(_first), a:patt) == -1) || (a:bang == 0 && match(getline(_first), a:patt) != -1)
			let _count=_count+1
		endif
		let _first=_first+1
	endwhile
	call cursor(a:cline, a:ccol)
	echo _count
endfunction

" Moves a tab in the specified direction count times
" a:dir "l" for left, other for right
" a:count number of moves
function! s:MoveTab(dir, count)
	let c = a:count
	if c == 0
		let c = 1
	endif
	let tn = tabpagenr()
	if a:dir == "l"
		let tn -= c + 1
	else
		let tn += c
	endif
	if tn < 0
		let tn = 0
	endif
	exe ":tabm " . tn
endfunction

" Toggles the size of the window, maximizes/unmaximizes
let s:vcmd = ''
function! s:WindowToggle(vert)
	if s:vcmd == ''
		let v = []
		for c in split(winrestcmd(), '|')
			let v = v + [c]
		endfor
		let s:vcmd = join(v, '|')
		vert resize
		resize
	else
		exe s:vcmd
		let s:vcmd = ''
	endif
endfunction

function! UrlEncode() range
	for i in range(a:firstline, a:lastline)
		let s = s:url_encode(getline(i))
		call setline(i, s)
	endfor
endfunction

function! UrlDecode() range
	for i in range(a:firstline, a:lastline)
		let s = s:url_decode(getline(i))
		call setline(i, s)
	endfor
endfunction

" From unimpaired
function! s:url_encode(str)
	return substitute(a:str,'[^A-Za-z0-9_.~-]','\="%".printf("%02X",char2nr(submatch(0)))','g')
endfunction

function! s:url_decode(str)
	let str = substitute(substitute(substitute(a:str,'%0[Aa]\n$','%0A',''),'%0[Aa]','\n','g'),'+',' ','g')
	return substitute(str,'%\(\x\x\)','\=nr2char("0x".submatch(1))','g')
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Project functions
function! LustyProjectFilePicker(only_current)
	QProject
	let g:current = Qcurrent_project()
	let ofnames = Qget_current_project_files(a:only_current)
	if len(ofnames) == 0
		echoerr "[No files detected]"
		return
	endif
	let g:cmd_arr = map(ofnames, "fnamemodify(v:val, ':.')")
	call QNamePickerStart(g:cmd_arr, {
				\ "complete_func": function("LustyProjectFileCompletion"),
				\ "acceptors": ["v", "s", "t", "\<M-V>", "\<M-S>", "\<M-T>"],
				\ "use_leader": 1,
				\})
endfunction

function! LustyProjectFileCompletion(index, key)
	if a:key == "\<M-V>" || a:key == "v"
		call Qopen_file('vert sp', g:current, g:cmd_arr[a:index])
	elseif a:key == "\<M-S>" || a:key == "s"
		call Qopen_file('sp', g:current, g:cmd_arr[a:index])
	elseif a:key == "\<M-T>" || a:key == "t"
		call Qopen_file('tabe', g:current, g:cmd_arr[a:index])
	else
		call Qopen_file('e', g:current, g:cmd_arr[a:index])
	endif
	QToggleProject
endfunction

" Taken from http://vim.wikia.com/wiki/Display_output_of_shell_commands_in_new_window
function! s:ExecuteInShell(command)
	let command = join(map(split(a:command), 'expand(v:val)'))
	let winnr = bufwinnr('^' . command . '$')
	silent! execute  winnr < 0 ? 'botright new ' . fnameescape(command) : winnr . 'wincmd w'
	setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
	echo 'Execute ' . command . '...'
	silent! execute 'silent %!'. command
	silent! execute 'resize ' . line('$')
	silent! redraw
	silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
	silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>'
	echo 'Shell command ' . command . ' executed.'
endfunction

function! Synname()
	if exists("*synstack")
		return map(synstack(line('.'),col('.')),'synIDattr(v:val,"name")')
	else
		return synIDattr(synID(line('.'),col('.'),1),'name')
	endif
endfunction
