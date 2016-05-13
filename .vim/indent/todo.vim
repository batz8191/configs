" Vim indent file
" Adapted from
" http://ifacethoughts.net/2008/05/11/task-management-using-vim/
" Language:	Todo
" Maintainer:	Matt Spear

if exists("b:did_indent")
	finish
endif
let b:did_indent = 1

setlocal indentexpr=TodoIndent(v:lnum)
setlocal indentkeys=-,o,O,1,2,3,4,5,6,7,8,9

if exists("*TodoIndent")
	finish
endif

let b:aoeu = []

function! TodoIndent(lnum)
	let lnum = a:lnum
	" At the start of the file use zero indent.
	if lnum == 0
		return 0
	endif
	let ind = indent(lnum-1)		" last indentation
	let cline = getline(lnum-1)		" last line
	let cind = indent(lnum)
	let cline = getline(lnum)		" current line
	let pos = col(".") - 1
	call extend(b:aoeu, ["line=" . cline])
	let i = matchend(cline, "^\\s*[\\-0-9]\\+\\s*")
	let r = indent
	if i > 0
		let r = i >= pos ? ind : cind
		call extend(b:aoeu, [lnum . ": " . i . " " . pos . " " . ind . " " . cind . " " . r])
	else
		let i = matchend(cline, "^\\s*")
		let r = i >= pos ? ind + &sw : cind
		call extend(b:aoeu, ["b:" . r])
	endif
	call extend(b:aoeu, [r])
	return r
endfunction
