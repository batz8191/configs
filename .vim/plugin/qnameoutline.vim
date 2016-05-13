"=============================================================================
" File: qnameoutline.vim
" Author: batman900 <batman900+vim@gmail.com>
" Last Change: 7/20/2013
" Version: 0.01

if v:version < 700
	finish
endif

if exists("g:qnameoutline_loaded") && g:qnameoutline_loaded
	finish
endif
let g:qnameoutline_loaded = 1

if !exists("g:qnameoutline_hotkey") || g:qnameoutline_hotkey == ""
	let g:qnameoutline_hotkey = "<S-F3>"
endif

if !hasmapto('QNameOutlineInit')
	exe "nmap <unique>" g:qnameoutline_hotkey ":call QNameOutlineInit(0, '', 1)<cr>:~"
endif

let s:funcs = {}
let s:names = {}
let s:scope = {}
let s:types = {}

function! QNameOutlineInit(height, typeFilter, useLeader)
	if len(s:types) == 0
		call s:init()
	endif
	call s:collect_tags(a:typeFilter)
	if len(g:cmd_arr) == 0
		return
	endif
	call QNamePickerStart(g:cmd_arr, {
				\ "complete_func": function("QNameOutlineCompletion"),
				\ "acceptors": [],
				\ "cancelors": ["g", "\<C-g>", g:qnameoutline_hotkey],
				\ "use_leader": a:useLeader,
				\ "height": a:height,
				\})
endfunction

function! QNameOutlineCompletion(index, key)
	call cursor(g:line_arr[a:index], 0)
	"unlet g:cmd_arr
	unlet g:line_arr
endfunction

function! s:collect_tags(typeFilter)
	let g:cmd_arr = []
	let filetype = &filetype
	if !has_key(s:types, filetype)
		echoerr "Unknown filetype " . filetype
		return
	endif
	let args = ['-f-',
			\ '--format=2',
			\ '--excmd=number',
			\ '--fields=nksSa',
			\ '--extra=',
			\ '--sort=no',
			\ '--language-force=' . s:names[filetype],
			\ '--' . s:names[filetype] . '-kinds=' . join(keys(s:types[filetype]), ''),
			\ fnamemodify(expand('%'), ':p'),
		\ ]
	let cmd = g:ctags_command
	for arg in args
            let cmd .= ' ' . shellescape(arg)
	endfor
	let ctags_out = system(cmd)
	if v:shell_error
		echoerr "Could not execute ctags"
		return
	endif
	let out = split(ctags_out, '\n\+')
	let g:line_arr = []
	for l in out
		let t = s:parse_line(l)
		if len(t) == 0
			echoerr "Could not parse " . l
		else
			let g:cmd_arr += [t[1]]
			let g:line_arr += [t[0]]
		endif
	endfor
endfunction

function! s:parse_line(line)
	let filetype = &filetype
	let fields = split(a:line, "\<Tab>")
	let type = fields[3]
	let line = 0
	let access = ''
	let signature = ''
	let scope = ''
	for x in fields[3:]
		let delimit = stridx(x, ':')
		let key = strpart(x, 0, delimit)
		" Remove all tabs that may illegally be in the value
		let val = substitute(strpart(x, delimit + 1), '\t', '', 'g')
		if len(val) > 0
			if key == 'line'
				let line = val
			elseif key == 'signature'
				let signature = val
			elseif key =~ '^class\|namespace\|enum$'
				let scope = val . s:scope[filetype]
			elseif key == 'access'
				let access = val . ' '
			endif
		endif
	endfor
	let Render = s:funcs[filetype]
	let o = Render(line, type, access, scope, fields[0], signature)
	if len(o) == 0
		return []
	endif
	return [line, o . ' (line ' . line . ')']
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Renderers
" Each render below takes the parts from ctags output, and constructs the
" string to display/search on
function! s:render_cpp(line, type, access, scope, name, signature)
	if a:type == 'f' || a:type == 'p'
		return a:access . a:scope . a:name . a:signature
	elseif a:type == 's' || a:type == 'c' || a:type == 'e' || a:type == 'g' || a:type == 'u'
		return a:access . s:types['cpp'][a:type] . ' ' . a:scope . a:name
	elseif a:type == 'd'
		" #defines don't contain a signature, so extract it manually
		let signature = matchstr(getline(a:line), '([^)]*)')
		return '#define ' . a:name . signature
	else
		echoerr "Unknown type " . a:type
		return ''
	endif
endfunction

function! s:render_go(line, type, access, scope, name, signature)
	if a:type == 'c' || a:type == 't'
		return s:types['go'][a:type] . ' ' . a:scope . a:name
	elseif a:type == 'f'
		" funcs don't contain a scope nor signature, so extract it manually
		let line = getline(a:line)
		let fr = a:name . ''
		let c = substitute(line, '^.*func\s*\((\([^ ]\+\s\+\)\=\*\=\([a-zA-Z0-9_]\+\))\).*', '\3', '')
		let f = substitute(line, '^.*\(' . a:name . '([^)]*)\).*', '\1', '')
		if c != line
			return c . s:scope['go'] . f
		endif
		return f
	else
		echoerr "Unknown type " . a:type
		return ''
	endif
endfunction


function! s:render_perl(line, type, access, scope, name, signature)
	if a:type == 'c' || a:type == 'f'
		return s:types['perl'][a:type] . ' ' . a:scope . a:name
	elseif a:type == 's'
		" subroutines don't contain a signature, so extract it manually
		" TODO they don't contain a scope, so we should search backward
		" for package...
		let signature = matchstr(getline(a:line), '([^)]*)')
		return 'sub ' . a:name . signature
	else
		echoerr "Unknown type " . a:type
		return ''
	endif
endfunction

function! s:render_vim(line, type, access, scope, name, signature)
	if a:type == 'f'
		let signature = matchstr(getline(a:line), '([^)]*)')
		return 'function ' . a:name . signature
	elseif a:type == 'a' || a:type == 'c' || a:type == 'm'
		return s:types['vim'][a:type] . ' ' . a:name
	endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Init
function! s:init()
	if !exists(g:ctags_command)
		" Taken from tagbar
		let cmds = ['ctags-exuberant'] " Debian
		let cmds += ['exuberant-ctags']
		let cmds += ['/usr/local/bin/ctags'] " Homebrew
		let cmds += ['/opt/local/bin/ctags'] " Macports
		let cmds += ['ectags'] " OpenBSD
		let cmds += ['ctags']
		let cmds += ['ctags.exe']
		let cmds += ['tags']
		for cmd in cmds
			if executable(cmd)
				let g:ctags_command = cmd
				break
			endif
		endfor
	endif
	" C
	let s:names['c'] = 'c'
	let s:funcs['c'] = function("s:render_cpp")
	let s:scope['c'] = '::'
	let s:types['c'] = {
				\ 'd': 'define',
				\ 'e': 'enumerators',
				\ 'f': 'function',
				\ 'g': 'enum',
				\ 'p': 'prototype',
				\ 's': 'struct',
				\ 'u': 'union',
			\ }
	" C++
	let s:names['cpp'] = 'c++'
	let s:funcs['cpp'] = function("s:render_cpp")
	let s:scope['cpp'] = '::'
	let s:types['cpp'] = {
				\ 'c': 'class',
				\ 'd': 'define',
				\ 'e': 'enumerators',
				\ 'f': 'function',
				\ 'g': 'enum',
				\ 'p': 'prototype',
				\ 's': 'struct',
				\ 'u': 'union',
			\ }
	" Go
	let s:names['go'] = 'go'
	let s:funcs['go'] = function("s:render_go")
	let s:scope['go'] = '.'
	let s:types['go'] = {
				\ 'f': 'func',
				\ 'c': 'const',
				\ 't': 'type',
			\ }
	" Java
	" TODO
	" Perl
	let s:names['perl'] = 'perl'
	let s:funcs['perl'] = function("s:render_perl")
	let s:scope['perl'] = '::'
	let s:types['perl'] = {
				\ 'c': 'use constant',
				\ 'f': 'format',
				\ 's': 'sub',
			\ }
	" Ruby
	" TODO
	" VIM
	let s:names['vim'] = 'vim'
	let s:funcs['vim'] = function("s:render_vim")
	let s:scope['vim'] = '.' " NOTE this won't occur
	let s:types['vim'] = {
				\ 'a': 'autocmd',
				\ 'c': 'command',
				\ 'f': 'function',
				\ 'm': 'map',
			\ }
endfunction
