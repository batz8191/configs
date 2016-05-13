" NOTE: You must, of course, install the ack script
"       in your path.
" On Debian / Ubuntu:
"   sudo apt-get install ack-grep
" On your vimrc:
"   let g:ackprg="ack-grep -H --nocolor --nogroup --column"
"
" With MacPorts:
"   sudo port install p5-app-ack

" Location of the ack utility
if !exists("g:ackprg")
	let g:ackprg="ack -H --nocolor --nogroup --column"
endif

function! s:Ack(cmd, type, args)
	redraw
	echo "Searching ..."
	call s:getBuffers()

	" If a type is specified then use it
	if !empty(a:type)
		let l:grepargs = '--type=' . a:type
	else
		let l:grepargs = ''
	endif

	" If no pattern is provided, search for the word under the cursor
	if empty(a:args)
		let l:grepargs .= ' ' . expand("<cword>")
	else
		let l:grepargs .= ' ' . a:args
	endif

	" Format, used to manage column jump
	if a:cmd =~# '-g$'
		let g:ackformat="%f"
	else
		let g:ackformat="%f:%l:%c:%m"
	endif

	echo a:cmd . ' ' . l:grepargs . "..."

	let grepprg_bak=&grepprg
	let grepformat_bak=&grepformat
	try
		let &grepprg=g:ackprg
		let &grepformat=g:ackformat
		silent execute a:cmd . " " . l:grepargs
	finally
		let &grepprg=grepprg_bak
		let &grepformat=grepformat_bak
	endtry

	if a:cmd =~# '^l'
		botright lopen
	else
		botright copen
	endif

	" TODO: Document this!
	exec "nnoremap <silent> <buffer> q :call <SID>close()<CR>"
	exec "nnoremap <silent> <buffer> <ESC> :call <SID>close()<CR>"
	exec "nnoremap <silent> <buffer> t :call <SID>openFile(1)<CR>"
	exec "nnoremap <silent> <buffer> <CR> :call <SID>openFile(0)<CR>"
	exec "nnoremap <silent> <buffer> o :call <SID>openFile(0)<CR>"
	exec "nnoremap <silent> <buffer> go <CR><C-W><C-W>"

	autocmd CursorMoved <buffer> nested call s:onCursorMoved()
	setlocal noautochdir

	" If highlighting is on, highlight the search keyword.
	if exists("g:ackhighlight")
		let @/=a:args
		set hlsearch
	end

	redraw!
endfunction

" Gets the list of open buffers
function! s:getBuffers()
	let g:buffers = []
	let _y = @y
	redir @y | silent ls | redir END
	for _line in split(@y, "\n")
		let _bno = matchstr(_line, '^ *\zs\d*')+0
		call add(g:buffers, _bno)
	endfor
	let @y = _y
endfunction

" Close any buffers opened by pedit
function! s:cleanBuffers()
	let _y = @y
	redir @y | silent ls | redir END
	for _line in split(@y, "\n")
		let _bno = matchstr(_line, '^ *\zs\d*')+0
		if index(g:buffers, _bno) == -1 && bufexists(_bno)
			exe "bdelete " . _bno
		endif
	endfor
	let @y = _y
endfunction

" Open the file on the current line
function! s:openFile(inTab)
	call s:close()
	let cmd = 'edit'
	if a:inTab
		let cmd = 'tabedit'
	endif
	silent! exec cmd . " +" . s:curResultLineNum . " " . s:curResultFileName
	setlocal nocursorline
endfunction

" Closos the preview window and the copen window
function! s:close()
	call s:getCurSearchResult()
	silent! exec "cclose"
	silent! exec "pclose"
	call s:cleanBuffers()
endfunction

" Move the cursor, and update the locations
function! s:onCursorMoved()
	let moved = 0
	let t:curResultRow = line(".")
	if exists("t:prevResultRow")
		if t:curResultRow != t:prevResultRow
			let moved = 1
			let t:prevResultRow = t:curResultRow
		endif
	else
		let t:prevResultRow = t:curResultRow
		let moved = 1
	endif
	if moved
		call s:previewFile()
	endif
endfunction

" Get the filename and line num for the current file
function! s:getCurSearchResult()
	let line = getline('.')
	let terms = split(line, '|')
	if len(terms) >= 2
		let linecol = split(terms[1], ' col ')
		if len(linecol) >= 2
			let s:curResultFileName = terms[0]
			let s:curResultLineNum = linecol[0]
		else
			let s:curResultFileName = ""
			let s:curResultLineNum = ""
		endif
	else
		let s:curResultFileName = ""
		let s:curResultLineNum = ""
	endif
endfunction

" Open the file on the current line in the preview window
function! s:previewFile()
	silent! exec "pclose"
	call s:getCurSearchResult()
	if filereadable(s:curResultFileName)
		exec 'pedit +' . s:curResultLineNum . ' ' . s:curResultFileName
		echo 'pedit +' . s:curResultLineNum . ' ' . s:curResultFileName
		silent! wincmd p
		setlocal cursorline
		silent! wincmd p
	endif
endfunction

" Convert a vim search to perl RE and ack on it
function! s:AckFromSearch(cmd, type, args)
	let search =  getreg('/')
	let search = substitute(search,'\(\\<\|\\>\)','\\b','g')
	call s:Ack(a:cmd, a:type, '"' .  search .'" '. a:args)
endfunction

" Quickfix window
command! -bang -nargs=* -complete=file Ack call s:Ack('grep<bang>','', <q-args>)
command! -bang -nargs=* -complete=file AckAdd call s:Ack('grepadd<bang>', '', <q-args>)
command! -bang -nargs=* -complete=file AckFromSearch call s:AckFromSearch('grep<bang>', '', <q-args>)

" Location window
command! -bang -nargs=* -complete=file LAck call s:Ack('lgrep<bang>', '', <q-args>)
command! -bang -nargs=* -complete=file LAckAdd call s:Ack('lgrepadd<bang>', '', <q-args>)
command! -bang -nargs=* -complete=file AckFile call s:Ack('grep<bang> -g', '', <q-args>)

" Some useful customizations for me
command! -bang -nargs=* -complete=file AckC call s:Ack('grep<bang>', 'cpp', <q-args>)
command! -bang -nargs=* -complete=file AckJ call s:Ack('grep<bang>', 'java', <q-args>)
command! -bang -nargs=* -complete=file AckCFromSearch call s:AckFromSearch('grep<bang>', 'cpp', <q-args>)
command! -bang -nargs=* -complete=file AckJFromSearch call s:AckFromSearch('grep<bang>', 'java', <q-args>)
