" Vim indent file
" Language:	acl
" Maintainer:	Matt Spear

if exists("b:did_indent")
	finish
endif
let b:did_indent = 1

setlocal indentexpr=AclIndent(v:lnum)
setlocal indentkeys=-,o,O,1,2,3,4,5,6,7,8,9

if exists("*AclIndent")
	finish
endif

function! AclIndent(lnum)
	let lnum = prevnonblank(v:lnum - 1)
	" At the start of the file use zero indent.
	if lnum == 0
		return 0
	endif
	let ind = indent(lnum)			" Current indentation
	let line = getline(lnum)		" last line
	let cline = getline(v:lnum)		" current line
	if line =~ '^\s*#'
		return ind
	elseif line !~ ';.*$' && line !~ '^\s'
		let ind = ind + 2 * &sw
	elseif line =~ ';.*$'
		let ind = 0
	endif
	return ind
endfunction
