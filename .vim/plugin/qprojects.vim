"=============================================================================
" File: qprojects.vim
" Author: batman900 <batman900+vim@gmail.com>
" Last Change: 12/1/2011
" Version: 0.01
" This is partialy copied from project.vim

if v:version < 700
	finish
endif

let s:project_head = '^\[[^\]\+]\]$'
let s:projects = {}
if !exists('g:project_filename')
	let g:project_filename = $HOME . '/.vimproject.cfg'
endif
if !exists('g:project_width')
	let g:project_width = 24
endif
let g:project_running = -1

" Public
function! Qget_current_project_files(only_current)
	return Qget_files(s:current_project, a:only_current)
endfunction

function! Qget_files(project, only_current)
	let project = s:get_project(a:project)
	if !exists('project') | return [] | endif
	let filecache = s:get_value(project, 'filecache', a:project)
	if !exists('filecache') | return [] | endif
	let root = s:get_value(project, 'root', a:project)
	if !exists('root') | return [] | endif
	let filecache = root . '/' . filecache
	if a:only_current
		return s:get_files_at_current_path(a:project, '=~', filecache)
	else
		return readfile(filecache)
	endif
endfunction

function! Qopen_file(editcmd, project, filename)
	let project = s:get_project(a:project)
	if !exists('project') | return | endif
	let root = s:get_value(project, 'root', a:project)
	if !exists('root') | return | endif
	let fname = escape(a:filename, ' %#')
	call <SID>do_setup()
	silent exec 'silent ' . a:editcmd . ' ' . fname
	silent exec 'cd ' . root
	if has_key(project, "in")
		exec 'source ' . project['in']
	endif
endfunction

function! Qcurrent_project()
	let lineno = line(".")
	let s:current_line = getline(lineno)
	while getline(lineno) !~ '^\[.\+\]$'
		let lineno -= 1
	endwhile
	let s:current_project = getline(lineno)
	return s:current_project
endfunction

" Private
function! s:start(filename)
	if !exists('g:project_running') || (bufwinnr(g:project_running) == -1)
		let cwd = getcwd()
		exec 'keepalt silent vertical new ' . a:filename
		exe "silent cd " . cwd
		silent! wincmd H
		exec 'vertical resize ' . g:project_width
		setlocal nomodeline
		let bufname = escape(substitute(expand('%:p', 0), '\\', '/', 'g'), ' ')
		setlocal buflisted
		let g:project_running = bufnr(a:filename)
		call s:parse(a:filename)
		call s:define_mappings()
		setlocal nobuflisted nowrap nonumber noswapfile
		set bufhidden=hide
	else
		silent! 99wincmd h
		if bufwinnr(g:project_running) == -1
			vertical split
			let v:errmsg = "nothing"
			silent! bnext
			if 'nothing' != v:errmsg
				enew
			endif
		endif
	endif
	call Qcurrent_project()
endfunction

function! s:define_mappings()
	nnoremap <buffer> <silent> <LocalLeader>r :call <SID>refresh_files(0)<CR>
	nnoremap <buffer> <silent> <LocalLeader>R :call <SID>refresh_files(1)<CR>
        nnoremap <buffer> <silent> <C-^> <Nop>
endfunction

function! s:toggle()
	if !exists('g:project_running') || bufwinnr(g:project_running) == -1
		call s:start(g:project_filename)
	else
		call s:hide()
	endif
endfunction

function! s:hide()
	let win = winnr()
	call s:start(g:project_filename)
	hide
	if winnr() != win
		wincmd p
	endif
	unlet win
endfunction

function! s:parse(filename)
	let mod = getftime(a:filename)
	if exists("g:project_modified") && mod == g:project_modified
		echo "Not Parsing " . a:filename
		return
	endif
	echo "Parsing " . a:filename . "[" . mod . ']'
	let g:project_modified = mod
	let lines = readfile(a:filename)
	let keys = ['root', 'in', 'filecache', 'filter']
	let current_project = ''
	let projects = {}
	for line in lines
		if len(line) == 0
			continue
		endif
		if line =~ '^\[.\+\]$'
			let current_project = line
			let projects[current_project] = {}
			let projects[current_project]["path"] = []
		else
			let kv = s:parse_line(current_project, line)
			if !exists("kv") | return | endif
			if kv[0] == 'path'
				if kv[1] =~ '^/'
					echoerr 'Path cannot start with /: ' . line
					return
				endif
				call add(projects[current_project]["path"], kv[1] == '.' ? '' : kv[1])
			elseif kv[0] == 'root'
				if kv[1] =~ '/$'
					echoerr 'Root cannot end in /: ' . line
					return
				endif
				let projects[current_project][kv[0]] = kv[1]
			else
				let projects[current_project][kv[0]] = kv[1]
			endif
		endif
	endfor
	let s:projects = projects
endfunction

function! s:parse_line(current_project, line)
	let list = matchlist(a:line, '^\([^=]\+\)=\(.\+\)')
	if len(list) < 3
		echoerr "Invalid line, no keypair found: " . a:line
		return
	endif
	if a:current_project == ''
		echoerr "Keypair given without a project: " . a:line
		return
	endif
	let key = list[1]
	let value = list[2]
	if key !~ '^\(root\|in\|filecache\|path\|filter\)'
		echoerr "Unknown key: " . key
		return
	endif
	return [key, value]
endfunction

function! s:get_project(project)
	if !has_key(s:projects, a:project)
		echoerr 'No such project: ' . a:project
		return
	endif
	return s:projects[a:project]
endfunction

function! s:get_value(project, key, project_name)
	if !has_key(a:project, a:key)
		echoerr "No " . a:key . " specified in project " . a:project_name
		return
	endif
	return a:project[a:key]
endfunction

function! s:refresh_files(only_current)
	call s:parse(g:project_filename)
	let project = s:get_project(s:current_project)
	if !exists('project') | return | endif
	if has_key(project, 'filter')
		let filter = project['filter']
		let ext = '{' . join(split(filter, ' '), ',') . '}'
	else
		let ext = '*'
	endif
	let filecache = s:get_value(project, 'filecache', s:current_project)
	if !exists('filecache') | return | endif
	let root = s:get_value(project, 'root', s:current_project)
	if !exists('root') | return | endif
	let path = s:get_value(project, 'path', s:current_project)
	if !exists('path') | return | endif
	let filecache = root . '/' . filecache
	let files = []
	if a:only_current
		let files = s:get_files_at_current_path(s:current_project, '!~', filecache)
		if !exists('files') | return | endif
		let kv = s:parse_line(current_project, line)
		if !exists("kv") | return | endif
		let path = [kv[1]]
	endif
	for p in path
		let t = root . '/' . p
		echo 'Globbing for ' . t . '/**/' . ext
		call extend(files, sort(split(globpath(t, '**/' . ext), "\n")))
	endfor
	echo "Writing to " . filecache
	call writefile(s:unique_sort(files), filecache)
endfunction

function! s:get_files_at_current_path(project, filter, filecache)
	let kv = s:parse_line(a:project, s:current_line)
	if !exists('kv') | return | endif
	if kv[0] != 'path'
		echoerr "Not on a line defining a path"
		return
	endif
	return filter(readfile(a:filecache), "v:val " . a:filter . " '" . kv[1] . "'")
endfunction

" Taken from project.vim
function! s:do_setup()
	let n = winnr()
	silent! wincmd p
	if n == winnr()
		silent! wincmd l
	endif
	if n == winnr()
		if bufnr('%') == g:project_running
			exec 'silent vertical new'
		else
			exec 'silent vertical split | silent! bnext'
		endif
	endif
endfunction

" Taken from
function! s:unique_sort(list, ...)
	let dictionary = {}
	for i in a:list
		let dictionary[string(i)] = i
	endfor
	let result = []
	if exists('a:1')
		let result = sort(values(dictionary), a:1)
	else
		let result = sort(values(dictionary))
	endif
	return result
endfunction

" Mappings/commands
command! QProject :call <SID>start(g:project_filename)
command! QHideProject :call <SID>hide()
command! QToggleProject :call <SID>toggle()
nnoremap <silent> <leader>p :QToggleProject<CR>
