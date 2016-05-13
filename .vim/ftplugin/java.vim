" Vim script file                                           vim600:fdm=marker:
" FileType:     java
" Author:       Batz

setlocal cindent
setlocal foldmethod=indent
"setlocal completefunc=javacomplete#CompleteParamsInfo
setlocal completeopt=menu,longest,preview


setlocal makeprg=javac\ %
setlocal errorformat=%f:%l:%m

"let java_highlight_functions="style"

"call Iab('pc', "public class «$1» {\<CR>«$2»\<CR>}")
"call Iab('rc', "private class «$1» {\<CR>«$2»\<CR>}")
"call Iab('class', "class «$1» {\<CR>«$2»\<CR>}")
"
"call Iab('p', "public «$1»")
"call Iab('o', "protected «$1»")
"call Iab('r', "private «$1»")
"call Iab('s', "static «$1»")
"call Iab('f', "final «$1»")
"call Iab('psf', "public static final «$1»")
"
"call Iab('func', "«$1» «$2»(«$3») «$3:throws «$4»» {\<CR>«$5»\<CR>}")
"call Iab('pf', "public «$1» «$2»(«$3») «$3:throws «$4»» {\<CR>«$5»\<CR>}")
"call Iab('of', "protected «$1» «$2»(«$3») «$3:throws «$4»» {\<CR>«$5»\<CR>}")
"call Iab('rf', "private «$1» «$2»(«$3») «$3:throws «$4»» {\<CR>«$5»\<CR>}")
"call Iab('pv', "public void «$1»(«$2») «$3:throws «$4»» {\<CR>«$5»\<CR>}")
"call Iab('ov', "protected void «$1»(«$2») «$3:throws «$4»» {\<CR>«$5»\<CR>}")
"call Iab('rv', "private void «$1»(«$2») «$3:throws «$4»» {\<CR>«$5»\<CR>}")
"
"call Iab('for', "for(«$1:int i = 0»; «$2:i < «$3»»; «$4:++i»)\<CR>{\<CR>«$5»\<CR>}")
"call Iab('fore', "for(«$1» : «$2»)\<CR>{\<CR>«$5»\<CR>}")
"
"call Iab('if', "if(«$1»)\<CR>{\<CR>«$2»\<CR>}")
"call Iab('else', "else\<CR>{\<CR>«$1»\<CR>}")
"call Iab('ife', "if(«$1»)\<CR>{\<CR>«$2»\<CR>}\<CR>else {\<CR>«$3»\<CR>}")
"call Iab('ifel', "if(«$1»)\<CR>{\<CR>«$2»\<CR>}\<CR>else if(«$3») {\<CR>«$4»\<CR>}")
"
"call Iab('while', "while(«$1»)\<CR>{\<CR>«$2»\<CR>}")
"call Iab('do', "do\<CR>{\<CR>«$1»\<CR>}\<CR>while(«$2»);")
"
"call Iab('i', "import «$1»;")
