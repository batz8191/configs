" Vim script file                                           vim600:fdm=marker:
" FileType:     todo
" Author:       Batz
" Adapted from http://ifacethoughts.net/2008/05/11/task-management-using-vim/

"if exists("b:did_ftplugin")
	"finish
"endif
let b:did_ftplugin = 1

if !exists("g:todo_add_comp")
	let g:todo_add_comp = 1
endif

if !exists("g:todo_browser")
	let g:todo_browser = "google-chrome"
endif

if !exists("g:todo_bin")
	let g:todo_bin = "dzen-cal"
endif

setlocal foldexpr=indent

" Pull in the jdn support
runtime plugin/jdn.vim

"=========================================================================================
" Helper functions

" setpos seems to have issues with storing curcol, easy hack
function! s:TodoSetpos(p)
	call setpos(".", a:p)
	norm! lh
endfunction

" Find the start of the current block
function! s:TodoStartBlock(callFunc, Func, arg)
	let l = line(".")
	let ind = indent(l)
	if a:callFunc
		call a:Func(l, a:arg)
	endif
	let l = l - 1
	while indent(l) > ind && l > 0
		if a:callFunc
			call a:Func(l, a:arg)
		endif
		let l = l - 1
	endwhile
	return l
endfunction

" Find the end of the current block
function! s:TodoEndBlock(callFunc, Func, arg)
	let l = line(".")
	let ind = indent(l)
	if a:callFunc
		call a:Func(l, a:arg)
	endif
	let l = l + 1
	while indent(l) > ind
		if a:callFunc
			call a:Func(l, a:arg)
		endif
		let l = l + 1
	endwhile
	return l
endfunction

" Evoke a web browser
function! s:TodoBrowser()
	let p = col(".") - 1 " match is 0-based, col is 1-based
	let line = getline(".")
	let i = match(line, "\\%(https\\=://\\|ftp://\\|www\\.\\)", 0)
	while i > 0
		let e = match(line, "\\s", i) - 1
		if i <= p && e >= p
			let line = strpart(line, i, e - i + 1)
			break
		elseif e < 0
			let line = strpart(line, i)
			break
		endif
		let i = match(line, "\\%(https\\=://\\|ftp://\\|www\\.\\)", e)
	endwhile
	if line =~ "^\\%(https\\=://\\|ftp://\\|www\\.\\)"
		let line = escape(line, "!#%")
		exec ":silent !" . g:todo_browser . " '" . line . "'"
		echo line
	endif
endfunction

"=========================================================================================
" date functions

" Prompt for a date, and add it to the current line at the head
function! s:TodoPromptDate(recurse)
	let o = system(g:todo_bin . ' --no-color --no-agenda  -M 3 ' . shellescape(expand('%:p')))
	let now = str2nr(strftime("%d"))
	let lines = split(o, "\n")
	for x in lines
		if match(x, '^[^|]*\<' . now . ' ') >= 0
			echo ''
			let nums = split(x, '')
			for n in nums
				if str2nr(n) == now
					let n = now < 10 ? ' ' . n : n
					echohl Search | echon n | echohl None
				else
					echon n
				endif
				echon ' '
			endfor
		else
			echo x
		endif
	endfor
	call inputsave()
	let inp = input("Date: ")
	call inputrestore()
	if len(inp)
		call <SID>TodoAddDate(a:recurse, inp)
	endif
endfunction

" Add the date parsed from the string to the current line
" if a:str starts with an @ it is copied verbatim
function! s:TodoAddDate(recurse, str)
	let now = split(strftime("%Y-%m-%d"), '-')
	call map(now, 'str2nr(v:val)')
	if match(a:str, '^@') == 0
		let r = a:str
	else
		let arr = split(a:str, ' ')
		let lst = split(arr[0], '-')
		let d = <SID>TodoParseDate(now, lst[0])
		if !len(d)
			return
		endif
		let r = '@' . d[1] . '/' . d[2] . '/' . d[0]
		if len(lst) > 1
			let d = <SID>TodoParseDate(d, lst[1])
			let r = r . '-' . d[1] . '/' . d[2] . '/' . d[0]
		endif
		if len(arr) > 1
			let r = r . ' ' . arr[1]
		endif
	endif
	let r = r . ' '
	let p = getpos(".")
	if a:recurse
		let F = function("s:TodoAddDateToLine")
		call <SID>TodoEndBlock(1, F, r)
	else
		call <SID>TodoAddDateToLine(p[1], r)
	endif
	call <SID>TodoSetpos(p)
endfunction

" Find the next occurence of date after the date in now.
" a:now is [year, month, day]
" a:date is <from>-<to> where from and to are one of:
" 	<day> The day of the current/next month
" 	<dow> The next day that matches the day-of-week specified.  A
" 		day-of-week can be one of:
" 		m for Monday
" 		t for Tuesday
" 		w for Wendsday
" 		r for Thursday
" 		f for Friday
" 		s for Saturday
" 		u for Sunday
" 	<month>/<day> The next month/day that is not passed
" 	<month>/<day>/<year> The fully specified date
" 	+<val><type> add the number specified to today the number's
" 		type is one of:
" 		d for days
" 		w for weeks
" 		m for months
" 		y for years
" 	-<val><type> subtract the number specified from today, the number's
" 		type is as above
function! s:TodoParseDate(now, date)
	let inp = a:date
	let now = a:now
	if match(inp, '^\d\d\=$') >= 0
		let lst = matchlist(inp, '^\(\d\d\=\)$')
		let add_one = 0
		let d = [now[0], now[1], lst[1]]
		if d[2] < now[2]
			let d[1] = d[1] + 1
			if d[1] > 12
				let d[1] = 1
				let d[0] = d[0] + 1
			endif
			let add_one = 1
		endif
		return d
	elseif match(inp, '^[mtwrfsu]$') >= 0
		let lst = matchlist(inp, '^\([mtwrfsu]\)$')
		let ds = stridx("mtwrfsu", lst[1])
		let jdn = jdn#jdn(now[0], now[1], now[2])
		while (jdn % 7) != ds
			let jdn = jdn + 1
		endwhile
		return jdn#to_gregorian(jdn)
	elseif match(inp, '^\d\d\=/\d\d\=$') >= 0
		let lst = matchlist(inp, '^\(\d\d\=\)/\(\d\d\=\)$')
		let d = [now[0], lst[1], lst[2]]
		if d[1] < now[1] || (d[1] == now[1] && d[2] < now[2])
			let d[0] = d[0] + 1
		endif
		return d
	elseif match(inp, '^\d\d\=/\d\d\=/\d\d\d\d$') >= 0
		let lst = matchlist(inp, '^\(\d\d\=\)/\(\d\d\=\)/\(\d\d\d\d\)$')
		return [lst[3], lst[1], lst[2]]
	elseif match(inp, '^[+\-]\d\+[dwmy]\?$') >= 0
		let lst = matchlist(inp, '^\([+-]\)\(\d\+\)\([dwmy]\)\?$')
		let jdn = jdn#jdn(now[0], now[1], now[2])
		let val = str2nr(lst[2])
		if lst[1] == '-'
			let val = -val
		endif
		if !len(lst[3])
			let lst[3] = 'd'
		end
		if lst[3] == 'y'
			let jdn = jdn#add_year(jdn, val)
		elseif lst[3] == 'm'
			let jdn = jdn#add_month(jdn, val)
		elseif lst[3] == 'w'
			let jdn = jdn + 7 * val
		else
			let jdn = jdn + val
		endif
		return jdn#to_gregorian(jdn)
	else
		echoerr "Bad date specification: " . inp
	endif
endfunction

"=========================================================================================
" Grep functions

" Find those lines which have any of the tags specified
function! s:TodoFindTag(...)
	let args = join(a:000, "\\|")
	echo args
	let i = 0
	let _file = expand("%")
	try
		exec "lvimgrep /\\C\\s:\\%(" . args . "\\)\\>/j " . _file
	catch /^Vim(\a\+):E480:/
	endtry
	exec "lw"
endfunction

" Runs the script over the current file and puts the output
" in a "scratch" buffer
function! s:TodoCal(agenda, ...)
	let args = a:000
	let i = 0
	let sargs = "--vim"
	let add_months = !a:agenda
	let add_agenda = a:agenda
	while i < len(args)
		if i == 0 && args[i] =~ '^\d\+$'
			let sargs = sargs . " -m " . args[i]
		elseif i == 1 && args[i] =~ '^\d\+$'
			let sargs = sargs . " -y " . args[i]
		else
			if args[i] == "-M" || args[i] == "--month" && i+1 < len(args)
				let add_months = 0
				let sargs = sargs . " " . args[i] . " " . args[i+1]
				let i = i+1
			elseif args[i] == "--agenda"
				let add_agenda = 0
				let sargs = sargs . " " . args[i]
			else
				let sargs = sargs . " " . args[i]
			endif
		endif
		let i = i + 1
	endwhile
	if add_months
		let sargs = sargs . " -M 3"
	endif
	if add_agenda
		let sargs = sargs . " --agenda"
	endif
	let file = expand("%")
	keepalt new
	exe "0r !" . g:todo_bin . " " . sargs . " " . file
	norm! gg0
	set ft=todocal
	set buftype=nofile
	set bufhidden=hide
	setlocal nomodifiable
	setlocal noswapfile
	echo g:todo_bin . " " . sargs . " " . file
	return bufnr('%')
endfunction

"=========================================================================================
" Cursor movement functions

" Move the cursor to the start of the line skipping the preamble.
" If the position does not change does a normal start.
" a:si controls if should end in insert mode
function! s:TodoStart(si)
	let line = getline(".")
	if line !~ '^\s*[\-0-9]\s'
		norm! ^
		if a:si
			startinsert
		endif
		return
	endif
	let n = stridx(line, "-")+1
	while n < strlen(line) && line[n] == ' '
		let n = n+1
	endwhile
	let p = getpos(".")
	if p[2] == n+1
		norm! ^
		if a:si
			startinsert
		endif
		return
	endif
	let p[2] = n+1
	call <SID>TodoSetpos(p)
	if a:si
		startinsert
	endif
endfunction

"=========================================================================================
" Functions that operate on a line (for calling from TodoEndBlock ond
" TodoStartBlock)

" Shift the line (indent or dedent)
" a:ind if should indent (false does dedent)
function! s:TodoTabToLine(line, ind)
	if a:ind
		exe "norm! " . a:line . "G>>"
	else
		exe "norm! " . a:line . "G<<"
	endif
endfunction

" Add a tag to the line, goes before any preexisting tags.
" If there are no tags then goes before the priority,
" if neither tags or priorities exist goes at the end.
function! s:TodoAddTagToLine(line, tag)
	exe "norm! " . a:line . "G"
	let line = getline(a:line)
	if line =~ " :" . a:tag . "\\>"
		return
	endif
	let pp = match(line, " =[a-z]") + 1
	let tp = match(line, " :[^: \\t]") + 1
	if tp > 0
		exe "norm! 0" . tp . "li:" . a:tag . " "
	elseif pp > 0
		exe "norm! 0" . pp . "li:" . a:tag . " "
	else
		exe "norm! A :" . a:tag
	endif
endfunction

" Adds the date specified to the head of the line specified
function! s:TodoAddDateToLine(line, date)
	exe "norm! " . a:line . "G"
	let line = getline(a:line)
	" TODO should remove any existing date
	let e = matchend(line, '^\s*[0-9\-]\+\s*')
	let g:debug = e . ' ' . line
	if e >= 0
		exec 'norm! 0' . e . 'li' . a:date
	else
		exec 'norm! I' . a:date
	endif
endfunction


" Adds/changes/toggles the priority (given by a:text).
" If a different priority exists it is replaced, if it
" is called on a line with the same priority it is toggled,
" otherwise it is added.  If g:todo_add_comp then an
" @comp <DATE> is added/removed.
function! s:TodoAddPriorityToLine(line, text)
	let add = a:text == "done"
	let line = getline(a:line)
	if match(line, "^\\s*[\\-0-9]") == -1
		return
	endif
	exe "norm! " . a:line . "G"
	let cp = stridx(line, " @comp")
	if cp > 0
		exe "norm! 0" . cp . "ld3E"
	endif
	let pp = match(line, " =[a-z]\\+\\>")
	if pp > 0
		if stridx(line, "=" . a:text, pp) > 0
			exe "norm! 0" . pp . "ldE"
			let add = 0
		else
			exe "norm! 0" . (pp+2) . "lcE" . a:text
		endif
	else
		exe "norm! A =" . a:text
	endif
	if g:todo_add_comp && add
		let d = strftime("%m/%d/%Y %I:%M%P")[1:-2] " Chop off the m
		exe "norm! A @comp " . d
	endif
endfunction

"=========================================================================================
" Complete functions
let s:omnistate = 0
fun! TodoComplete(findstart, base)
	if a:findstart
		" locate the start of the word
		let line = getline('.')
		let start = min([col('.') - 1, strlen(line) - 1])
		while start > 0 && line[start-1] =~ '[^ \t:=]'
			let start -= 1
		endwhile
		if start > 0
			let s:omnistate = line[start-1] == ':' ? 1 : line[start-1] == '=' ? 2 : 0
		else
			let s:omnistate = 0
		endif
		"let g:start = "[" . line[start] . "] [ ] " . start . ' ' . (strlen(line) - 1) . ' ' . (col('.') - 1) . ' ' . s:omnistate
		return start
	else
		let g:t = []
		if s:omnistate == 2 " =<PRIORITY> completion
			let res = []
			for m in split("low med high")
				if match(m, '\V' . a:base) == 0
					call add(res, m)
				endif
			endfor
			return res
		else " :<TAG>/<WORD> completion
			let re = s:omnistate == 1 ? '\s:[^ \t]\+' : '\<\w\+\>'
			"let g:start .= ' ' . re
			let g:t = []
			let save_cursor = getpos(".")
			call cursor(1, 1)
			let g:base = a:base
			while search(re, 'W') > 0
				let m = expand("<cword>")
				if match(m, '\V' . a:base) == 0
					call add(g:t, m)
				endif
			endwhile
			call setpos('.', save_cursor)
			return g:t
		endif
	endif
endfun

"=========================================================================================
" General functions

" Indent the section
function! s:TodoAddTab(recurse, indent)
	let p = getpos(".")
	if a:recurse
		let F = function("s:TodoTabToLine")
		call <SID>TodoEndBlock(1, F, a:indent)
	else
		if getline(".") =~ "^\\s*$"
			if a:indent
				exe "norm! I\<TAB>"
			else
				exe "norm! 0\"_x"
			endif
		else
			call <SID>TodoTabToLine(p[1], a:indent)
		endif
	endif
	if a:indent
		let p[2] = p[2] + 1
	else
		let p[2] = p[2] - 1
	endif
	call <SID>TodoSetpos(p)
endfunction

" Prompt for a tag to add and call TodoAddTag
" a:recurse if should add to all children too
function! s:TodoGetAddTag(recurse)
	call inputsave()
	let tag = input("Tag: ")
	call inputrestore()
	call <SID>TodoAddTag(a:recurse, tag)
endfunction

" Adds the specified tag
" a:recurse if should add to all children too
" a:tag the tag to add
function! s:TodoAddTag(recurse, tag)
	if strlen(a:tag) > 0
		let p = getpos(".")
		if a:recurse
			let F = function("s:TodoAddTagToLine")
			call <SID>TodoEndBlock(1, F, a:tag)
		else
			call <SID>TodoAddTagToLine(p[1], a:tag)
		endif
		call <SID>TodoSetpos(p)
	endif
endfunction

" Toggle the priority to the given text
" a:recurse if should add to all children too
" a:text the priority to set
function! s:TodoSetPriority(recurse, text)
	let p = getpos(".")
	if a:recurse
		let F = function("s:TodoAddPriorityToLine")
		call <SID>TodoEndBlock(1, F, a:text)
	else
		call <SID>TodoAddPriorityToLine(p[1], a:text)
	endif
	call <SID>TodoSetpos(p)
endfunction

" Executes a move that also moves all children
" a:down conntrols if the move is down or up
function! s:TodoMove(down)
	let p = getpos(".")
	let s = p[1]
	let e = <SID>TodoEndBlock(0, 0, 0) - 1
	if a:down
		exe "norm! " . (e+1) . "G"
		let ne = <SID>TodoEndBlock(0, 0, 0) - 1
		exe s . "," . e . " move " . (ne-1) . "+1"
		let p[1] = p[1] + (ne - e)
	else
		exe "norm! " . s . "G"
		let ns = <SID>TodoStartBlock(0, 0, 0)
		exe s . "," . e . " move " . ns . "-1"
		let p[1] = p[1] - (s - ns)
	endif
	call <SID>TodoSetpos(p)
endfunction

" Continue the previous line's control structure
function! s:TodoContinue(below, ins)
	let line = getline(".")
	let ind = indent(".")
	if a:ins && col(".") < col("$")-1
		exe "norm! a\<RETURN>"
		return
	endif
	let o = a:below ? "o" : "O"
	if match(line, '^\s*[\-0-9]') >= 0
		exe "norm! " . o . "- "
	else
		let g = matchlist(line, '^\s*\(\d\+\)')
		if len(g) > 0
			let x = str2nr(g[1])+1
			exe "norm! " . o . x . " "
		else
			" XXX a hack to make it trigger the indent, not sure why the
			" -<BS> is needed
			exe "norm! " . o . "-\<BS>"
		endif
	endif
endfunction

"=========================================================================================
" Commands
command! -buffer High :exec "lvimgrep /=high\\>/j " . expand('%') | exec "lw"
command! -buffer Medium :exec "lvimgrep /=med\\>/j " . expand('%') | exec "lw"
command! -buffer Low :exec "lvimgrep /=low\\>/j " . expand('%') | exec "lw"
command! -buffer -nargs=+ Tag call <SID>TodoFindTag(<f-args>)
command! -buffer -nargs=* Calendar call <SID>TodoCal(0, <f-args>)
command! -buffer -nargs=* Agenda call <SID>TodoCal(1, <f-args>)
command! -buffer -nargs=1 -bang AddTag call <SID>TodoAddTag("<bang>" != "", <q-args>)
command! -buffer -nargs=+ -bang AddDate call <SID>TodoAddDate("<bang>" != "", <q-args>)

"=========================================================================================
" settings
setlocal omnifunc=TodoComplete
imap <buffer> <silent> <C-SPACE> <C-R>=<SID>CleverTab(1)<CR>
imap <buffer> <silent> <C-S-SPACE> <C-R>=<SID>CleverTab(0)<CR>

function! s:CleverTab(dir)
	if pumvisible()
		if a:dir==1
			return "\<C-N>"
		else
			return "\<C-P>"
		endif
	endif
	return "\<C-X>\<C-O>"
endfunction

"=========================================================================================
" imaps
imap <buffer> <silent> <TAB> <ESC>:call <SID>TodoAddTab(0, 1)<CR>a
imap <buffer> <silent> <S-TAB> <ESC>:call <SID>TodoAddTab(0, 0)<CR>a
imap <buffer> <silent> <M-k> <ESC>:move .-2<CR>
imap <buffer> <silent> <M-UP> <ESC>:move .-2<CR>
imap <buffer> <silent> <M-j> <ESC>:move .+1<CR>i
imap <buffer> <silent> <M-DOWN> <ESC>:move .+1<CR>i

imap <buffer> <silent> <M-LEFT> <ESC>:call <SID>TodoAddTab(0, 0)<CR>a
imap <buffer> <silent> <M-RIGHT> <ESC>:call <SID>TodoAddTab(0, 1)<CR>a

imap <buffer> <silent> <RETURN> <ESC>:call <SID>TodoContinue(1, 1)<CR>a
imap <buffer> <silent> <S-RETURN> <ESC>:call <SID>TodoContinue(0, 1)<CR>a
"imap <buffer> <silent> <S-RETURN> <ESC>:norm! \<RETURN><CR>

"=========================================================================================
" nmaps
nmap <buffer> <silent> <LOCALLEADER>k :move .-2<CR>
nmap <buffer> <silent> <LOCALLEADER>j :move .+1<CR>
nmap <buffer> <silent> <M-k> :move .-2<CR>
nmap <buffer> <silent> <M-UP> :move .-2<CR>
nmap <buffer> <silent> <M-j> :move .+1<CR>
nmap <buffer> <silent> <M-DOWN> :move .+1<CR>

nmap <buffer> <silent> I :call <SID>TodoStart(1)<CR>
nmap <buffer> <silent> ^ :call <SID>TodoStart(0)<CR>
nmap <buffer> <silent> <HOME> :call <SID>TodoStart(0)<CR>

nmap <buffer> <silent> <RETURN> :call <SID>TodoContinue(1, 0)<CR>A
nmap <buffer> <silent> <S-RETURN> :call <SID>TodoContinue(0, 0)<CR>A
nmap <buffer> <silent> <C-RETURN> :call <SID>TodoBrowser()<CR>

nmap <buffer> <silent> <LOCALLEADER>2 :call <SID>TodoPromptDate(0)<CR>
nmap <buffer> <silent> <LOCALLEADER>t :call <SID>TodoGetAddTag(0)<CR>
nmap <buffer> <silent> <LOCALLEADER>d :call <SID>TodoSetPriority(0, "done")<CR>
nmap <buffer> <silent> <LOCALLEADER>h :call <SID>TodoSetPriority(0, "high")<CR>
nmap <buffer> <silent> <LOCALLEADER>m :call <SID>TodoSetPriority(0, "med")<CR>
nmap <buffer> <silent> <LOCALLEADER>l :call <SID>TodoSetPriority(0, "low")<CR>

nmap <buffer> <silent> <M-LEFT> :call <SID>TodoAddTab(0, 0)<CR>
nmap <buffer> <silent> <M-RIGHT> :call <SID>TodoAddTab(0, 1)<CR>
nmap <buffer> <silent> <TAB> :call <SID>TodoAddTab(0, 1)<CR>
nmap <buffer> <silent> <S-TAB> :call <SID>TodoAddTab(0, 0)<CR>

nmap <buffer> <silent> <LOCALLEADER>@ :call <SID>TodoPromptDate(1)<CR>
nmap <buffer> <silent> <LOCALLEADER>T :call <SID>TodoGetAddTag(1)<CR>
nmap <buffer> <silent> <LOCALLEADER>D :call <SID>TodoSetPriority(1, "done")<CR>
nmap <buffer> <silent> <LOCALLEADER>H :call <SID>TodoSetPriority(1, "high")<CR>
nmap <buffer> <silent> <LOCALLEADER>M :call <SID>TodoSetPriority(1, "med")<CR>
nmap <buffer> <silent> <LOCALLEADER>L :call <SID>TodoSetPriority(1, "low")<CR>

nmap <buffer> <silent> <M-S-LEFT> :call <SID>TodoAddTab(1, 0)<CR>
nmap <buffer> <silent> <M-S-RIGHT> :call <SID>TodoAddTab(1, 1)<CR>
nmap <buffer> <silent> <LOCALLEADER><TAB> :call <SID>TodoAddTab(1, 1)<CR>
nmap <buffer> <silent> <LOCALLEADER><S-TAB> :call <SID>TodoAddTab(1, 0)<CR>

nmap <buffer> <silent> <LOCALLEADER>K :call <SID>TodoMove(0)<CR>
nmap <buffer> <silent> <LOCALLEADER>J :call <SID>TodoMove(1)<CR>
nmap <buffer> <silent> <M-S-UP> :call <SID>TodoMove(0)<CR>
nmap <buffer> <silent> <M-S-DOWN> :call <SID>TodoMove(1)<CR>
nmap <buffer> <silent> <M-S-k> :call <SID>TodoMove(0)<CR>
nmap <buffer> <silent> <M-S-j> :call <SID>TodoMove(1)<CR>

"=========================================================================================
" vmaps
vmap <buffer> <silent> <M-k> :move '<-2<CR>gv
vmap <buffer> <silent> <M-UP> :move '<-2<CR>gv
vmap <buffer> <silent> <M-j> :move '>+1<CR>gv
vmap <buffer> <silent> <M-DOWN> :move '>+1<CR>gv

" Start with all lines collapsed
exec "norm zM"
