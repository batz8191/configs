" Vim script file                                           vim600:fdm=marker:
" FileType:     wiki
" Author:       Batz

setlocal textwidth=90
setlocal formatoptions+=t
setlocal iskeyword+=_,-,\
setlocal complete+=k

syntax spell toplevel

"call Iab('\eq', "\\begin{equation}<CR>«$1»<CR>\end{equation}")
"call Iab('\eqs', "\\begin{equation*}<CR>«$1»<CR>\end{equation*}")
"call Iab('\align', "\\begin{align}<CR>«$1»<CR>\end{align}")
"call Iab('\cases', "\\begin{cases}<CR>«$1» & «$2:\text{if }» \\<CR>«$4»<CR>\end{cases}")
"
"call Iab('\tbf', "\\textbf{«$1»}")
"call Iab('\ttt', "\\texttt{«$1»}")
"call Iab('\tit', "\\textit{«$1»}")
