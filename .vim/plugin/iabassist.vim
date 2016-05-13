"=============================================================================
" File: iabassist.vim
" Author: batman900 <batman900+vim@gmail.com>
" Last Change: 22-Jun-2009.
" Version: 0.02
" Usage:
"
"	:Iab("lhs", "rhs")
"	then lhs<Tab> to expand to rhs
"
"	:VisIab('lhs', 'rhs')
"	Then line-select and call Wrap (tab complete for the lhs)
"	«$TXT» will be replaced with the selected text
"
"	,, select next placeholder
"	<TAB> select next placeholder
"	,. set default for the current placeholder
"	,' delete the current placeholder

" Do not load more than once, but allow the user to force reloading if deisred
if exists('s:loaded_iabassist') && s:loaded_iabassist == 1
	finish
endif
let s:loaded_iabassist = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Insert Mode

" Delete the character under the cursor if it is a space
function! Eatchar()
	let c = nr2char(getchar())
	return (c =~ '\s') ? '' : c
endfunction

" Get the syntax style of the item under the cursor
function! s:SyntaxAtCursor()
	return synIDattr(synIDtrans(synID(line("."), col(".")-1, 1)), "name")
endfunction

" Create abbreviation suitable for ExpandIfSafe
" a:ab is the abbreviation to define
" a:full is the full text to replace a:ab with
function! Iab(ab, full)
	if !exists('b:iabassist_dont_expand')
		let b:iabassist_dont_expand = 'comment\|string\|character\|doxygen\|bibbrace'
	endif
	if !exists('b:abbrevs')
		let b:abbrevs = {}
	endif
	let b:abbrevs[a:ab] = a:full
endfunction

" Select the next «$i» item
function! IabSelectNext(doNormal, backwards, complete)
	if !exists('b:abbrevs') || len(b:abbrevs) == 0
		return a:complete ? "\<TAB>" : ""
	endif
	let syn = s:SyntaxAtCursor()
	let word = matchstr(getline('.'), '\S\+\%' . col('.') . 'c')
	if a:complete && has_key(b:abbrevs, word) && syn !~? b:iabassist_dont_expand
		let col = col('.') - len(word)
		sil exe 's/\V' . escape(word, '/.') . '\%#//'
		" TODO this is a giant hack, do I ever want to do an expansion
		" not at the end of a line?
		return "\<ESC>A" . b:abbrevs[word]
	endif
	if a:backwards
		let flags = 'bcw'
		let s = '«\$1[^»]*'
	else
		let flags = 'cw'
		let s = '«\$\d\+[^»]*'
	endif
	if search(s, flags) > 0
		let curl = line(".")
		let curc = col(".")
		call searchpair('«', '', '»')
		normal! m'
		call cursor(curl, curc)
		if curc == 1
			return "\<ESC>v``l\<C-G>"
		else
			return "\<ESC>lv``l\<C-G>"
		endif
	elseif a:doNormal
		return "\<TAB>"
	else
		return ""
	endif
endfunction

function! IabSelectDefault()
	let curl = line(".")
	let curc = col(".")
	call searchpair('«', '', '»')
	normal! "_x
	call cursor(curl, curc)
	normal! "_df:
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Visual-Line Mode
function! VisIab(ab, full, format)
	if !exists('b:iabassist_vis')
		let b:iabassist_vis = {}
	endif
	let b:iabassist_vis[a:ab] = {'full': a:full, 'format': a:format}
	exe "command! -complete=custom,s:IabComplete -nargs=1 -range Wrap call <SID>wrap(<q-args>)"
endfunction

function! s:wrap(name)
	if !has_key(b:iabassist_vis, a:name)
		echoerr "Could not find definition for " . a:name
		return
	endif
	let s = substitute(b:iabassist_vis[a:name].full, '<CR>', "\<C-M>", 'g')
	let a = split(s, '«$TXT»')
	let p = &paste
	set paste
	exe "norm! `<mxi" . a[0]
	exe "norm! `>a" . a[1]
	if b:iabassist_vis[a:name].format
		exe "norm V'x=,,"
	endif
	if !p | set nopaste | endif
endfunction

function! s:IabComplete(A,L,P)
	return join(keys(b:iabassist_vis), "\n")
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings

" Accept the default and select the next placeholder
snoremap <silent> ,. <ESC>`<:call IabSelectDefault()<CR>a<C-R>=IabSelectNext(0, 0, 0)<CR>

" Deltete the currently selected item, and select the next placeholder
snoremap <silent> ,' <C-G>"_xa<C-R>=IabSelectNext(0, 0, 0)<CR>

" Select the next placeholder
inoremap <silent> <TAB> <C-R>=IabSelectNext(1, 0, 1)<CR><C-R>=IabSelectNext(0, 1, 0)<CR>
nnoremap <silent> ,, a<C-R>=IabSelectNext(1, 0, 0)<CR>
