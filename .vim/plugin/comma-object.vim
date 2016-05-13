" A Vim plugin that defines a comma text object.
"
" This script defines a comma text object. A comma object is text relating
" to a parameter with the pairs (), [], {}.  This script is mostly from
" http://www.vim.org/scripts/script.php?script_id=2699 with minor
" modifications to change the definition.
"
" See:
" :help text-objects
"   for a description of what can be done with text objects.

if exists("loaded_parameter_objects") && loaded_parameter_objects
	finish
endif
let loaded_parameter_objects = 1

vmap <silent> i, <Plug>ParameterObjectI
omap <silent> i, <Plug>ParameterObjectI
vmap <silent> a, <Plug>ParameterObjectA
omap <silent> a, <Plug>ParameterObjectA
vnoremap <silent> <script> <Plug>ParameterObjectI :<C-U>call <SID>parameter_object("i")<cr>
onoremap <silent> <script> <Plug>ParameterObjectI :call <SID>parameter_object("i")<cr>
vnoremap <silent> <script> <Plug>ParameterObjectA :<C-U>call <SID>parameter_object("a")<cr>
onoremap <silent> <script> <Plug>ParameterObjectA :call <SID>parameter_object("a")<cr>

function! s:parameter_object(mode)
	let ve_save = &ve
	set virtualedit=onemore
	let l_save = @l
	try
		" Search for the start of the parameter text object
		if searchpair('[\[{(]', ',', '[\]})]', 'bWs', "s:skip()") <= 0
			return
		endif
		normal! "lyl
		let startparen = 0
		if a:mode == "a" && @l == '('
			let startparen = 1
		endif
		if a:mode == "a" && @l == ','
			let gotone = 1
			normal! ml
		else
			" Inner, skip whitespace
			if a:mode == "i"
				if search("[^ \t\r\n]", "W") == 0
					normal! l
				endif
			else
				normal! l
			endif
			normal! mlh
		endif
		let c = v:count1
		while c
			" Search for the end of the parameter text object
			if searchpair('[\[{(]', ',', '[\]})]', 'W', "s:skip()") <= 0
				normal! `'
				return
			endif
			normal! "lyl
			if @l == ')' && c > 1
				" found the last parameter when more is asked for, so abort
				normal! `'
				return
			endif
			if startparen && @l == ','
				normal! w
			endif
			let c -= 1
		endwhile
		normal! v`l
	finally
		let &ve = ve_save
		let @l = l_save
	endtry
endfunction

function! s:skip()
	let name = synIDattr(synID(line("."), col("."), 0), "name")
	if name =~? "comment"
		return 1
	elseif name =~? "string"
		return 1
	endif
	return 0
endfunction
