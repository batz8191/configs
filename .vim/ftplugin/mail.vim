" TODO make this work with quoted text
function! CheckAttach()
	let val='attach[^:]\?\|attachment\|attached'
	let oldPos=getpos('.')
	let ans=1
	1
	if search('\%('.val.'\)','W')
		let ans=input("Attach file?: (leave empty to abbort): ", "", "file")
		while (ans != '')
			normal magg}-
			call append(line('.'), 'Attach: '.ans)
			redraw
			let ans=input("Attach another file?: (leave empty to abbort): ", "", "file")
		endwhile
	endif
	exe ":write ". expand("<amatch>")
	call setpos('.', oldPos)
endfun

function! s:Attach(file)
	let oldPos=getpos('.')
	normal magg}-
	call append(line('.'), 'Attach: ' . a:file)
endfun

command! -nargs=* -complete=file Attach :call <SID>Attach("<args>")

augroup script
	au!
	au BufWriteCmd,FileWriteCmd mutt* :call CheckAttach()
augroup END
