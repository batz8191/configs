"=============================================================================
" FILE: qproject.vim
" AUTHOR:  Batz <batman900@gmail.com>
" Last Modified: 09 Jul 2013.
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Variables  "{{{
"}}}

function! unite#sources#qproject#define() "{{{
  return s:source
endfunction"}}}

let s:source = {
      \ 'name' : 'qproject',
      \ 'description' : 'candidate from qproject',
      \ 'default_kind' : 'guicmd',
      \ }

function! s:source.gather_candidates(args, context) "{{{
  let ofnames = Qget_current_project_files(get(a:args, 0, 0))
  if len(ofnames) == 0
	  echoerr "[No files detected]"
	  return []
  endif
  let files = map(ofnames, "fnamemodify(v:val, ':.')")
  return map(files, 'unite#sources#qproject#create_file_dict(v:val)')
endfunction"}}}

function! unite#sources#qproject#create_file_dict(file) "{{{
	let dict = {
		\ 'word' : a:file,
		\ 'abbr' : a:file,
		\ 'action__path' : fnamemodify(a:file, ':p'),
		\ 'kind' : 'file'
		\ }
	return dict
endfunction "}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
