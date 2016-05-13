" Vim script file                                           vim600:fdm=marker:
" FileType:     c
" Author:       Batz

setlocal iskeyword+=_
setlocal cindent
setlocal foldmethod=syntax

" Set up ctags support
"let OmniCpp_ShowPrototypeInAbbr=1
"let OmniCpp_ShowScopeInAbbr=1
"let OmniCpp_SelectFirstItem=0
"let OmniCpp_NamespaceSearch=1
"let OmniCpp_GlobalScopeSearch=1
"let OmniCpp_ShowAccess=1
"let OmniCpp_MayCompleteDot=1
"let OmniCpp_MayCompleteArrow=1
"let OmniCpp_MayCompleteScope=0
" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview
set tags+=~/.vim/tags/stl
set tags+=~/.vim/tags/code
map <C-F12> :!ctags -R --c++-kinds=+pl --fields=+ianS --extra=+fq .<CR>

call Iab('@c', "\/\/ Written \<C-R>=strftime('%Y')\<CR>\<CR>\<C-U>")

call Iab('@c', "\/\/ Copyright \<C-R>=strftime('%Y')\<CR>\<C-U>")

call Iab('struct', "struct «$1» {\<CR>«$2»\<CR>};")
call Iab('tstruct', "typedef struct {\<CR>«$1»\<CR>} «$2»;")

call Iab('bool', "bool «$1»;")
call Iab('int', "int «$1»;")
call Iab('unsigned', "unsigned «$1»;")
call Iab('string', "string «$1»;")

call Iab('func', "«$1» «$2»(«$3») {\<CR>«$4»\<CR>}")

call Iab('for', "for («$1:unsigned i = 0»; «$2:i < «$3»»; «$4:++i») {\<CR>«$5»\<CR>}")

call Iab('if', "if («$1») {\<CR>«$2»\<CR>}")
call Iab('else', "else {\<CR>«$1»\<CR>}")
call Iab('ife', "if («$1») {\<CR>«$2»\<CR>} else {\<CR>«$3»\<CR>}")
call Iab('ifel', "if («$1») {\<CR>«$2»\<CR>} else if («$3») {\<CR>«$4»\<CR>}")

call Iab('while', "while («$1») {\<CR>«$2»\<CR>}")
call Iab('do', "do {\<CR>«$1»\<CR>} while(«$2»);")

call Iab('#i', "#include <«$1»>")
call Iab('#I', "#include \"«$1»\"")
call Iab('#D', "#ifndef «$1»\<CR>#define «$2»\<CR>\<CR>«$3»\<CR>\<CR>#endif  // «$4»")
call Iab('#d', "#define «$1»")

call VisIab('if', "if («$1») {\<CR>«$TXT»\<CR>}", 1)
call VisIab('else if', "else if («$1») {\<CR>«$TXT»\<CR>}", 1)
call VisIab('else', "else {\<CR>«$TXT»\<CR>}", 1)
call VisIab('while', "while («$1») {\<CR>«$TXT»\<CR>}", 1)
call VisIab('do', "do {\<CR>«$TXT»\<CR>} while(«$1»);", 1)
call VisIab('for', "for («$1:unsigned i = 0»; «$2:i < «$3»»; «$4:++i») {\<CR>«$TXT»\<CR>}", 1)
call VisIab('guard', "#ifndef «$1»\<CR>#define «$1»\<CR>\<CR>«$TXT»\<CR>\<CR>#endif", 1)
call VisIab('namespace', "namespace «$1» {\<CR>«$TXT»\<CR>}  // namespace «$1»\<CR>", 1)
