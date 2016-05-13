" Vim script file                                           vim600:fdm=marker:
" FileType:     tex
" Author:       Batz

setlocal textwidth=90
setlocal iskeyword+=_,-,\
setlocal formatoptions+=tc
setlocal makeprg=latex\ -file-style-error\ -interaction=nonstopmode\ %\ $*\ \\\|\ grep\ -i\ -e\ \"LaTeX\ Warning\\|\\w\\+\\.tex:[0-9]\\+:\\(.*\\)\"<CR>
setlocal errorformat=%f:%l:\ %m

setlocal indentexpr=GetTeXIndent()
setlocal nolisp
setlocal nosmartindent
setlocal autoindent
setlocal indentkeys+=},=\\item,=\\bibitem
setlocal complete+=k

syntax spell toplevel

map <silent> <buffer> <S-F10> :setl makeprg=latex\ -file-style-error\ -interaction=nonstopmode\ %\ $*\ \\\|\ grep\ -i\ -e\ \"LaTeX\ Warning\\|\\w\\+\\.tex:[0-9]\\+:\\(.*\\)\"<CR>:copen<CR><C-W>L<C-W>h
imap <silent> <buffer> <S-F10> <ESC>:setl makeprg=latex\ -file-style-error\ -interaction=nonstopmode\ %\ $*\ \\\|\ grep\ -i\ -e\ \"LaTeX\ Warning\\|\\w\\+\\.tex:[0-9]\\+:\\(.*\\)\"<CR>:copen<CR><C-W>L<C-W>h

command! -complete=custom,ListE -nargs=1 -range LE normal <line1>ggO\begin{<args>}<Esc><line2>ggjo\end{<args>}<Esc><line1>ggv<line2>ggjj=

fun! ListCE(A,L,P)
	return "algorithm\nalgorithmic\nalign*\nblock\ncases\ncenter\ncolumns\nenumerate\nequation\nequation*\nfigure\nframe\nitemize\nlemma\nlstlisting\nonlyenv\noverlayarea\nproof\npsmatrix\ntable\ntabular\ntheorem"
endfun

"call Iab('\inc', "\input{«$1»}")
"call Iab('\nc', "\newcommand{«$1»}«$2:[«$3»]»{«$4»}")
"call Iab('\nabv', "\newabbrev{«$1»}{«$2»}[«$3»]")
"
"call Iab('\enum', "\begin{enumerate}\<CR>\item «$1»\<CR>\end{enumerate}")
"call Iab('\ienum', "\begin{inparaenum}[«$1:1)»]\<CR>\item «$2»\<CR>\end{inparaenum}")
"call Iab('\aenum', "\begin{asparaenum}[«$1:1)»]\<CR>\item «$2»\<CR>\end{asparaenum}")
"
"call Iab('\itemize', "\begin{itemize}\<CR>\item «$1»\<CR>\end{itemize}")
"call Iab('\iitemize', "\begin{inparaitem}«$1:[$\bullet$]»\<CR>\item «$2»\<CR>\end{inparaitem}")
"call Iab('\aitemize', "\begin{asparaitem}«$1:[$\bullet$]»\<CR>\item «$2»\<CR>\end{asparaitem}")
"
"call Iab('\desc', "\begin{description}\<CR>\item[«$1»] «$2»\<CR>\end{description}")
"
"call Iab('\slide', "\begin{slide}{«$1»}\<CR>«$2»\<CR>\end{slide}")
"call Iab('\eslide', "\begin{emptyslide}{«$1»}\<CR>«$2»\<CR>\end{emptyslide}")
"call Iab('\twocolumn', "\twocolumn{\<CR><TAB>«$1»\<CR>\<BS>}{\<CR><TAB>«$2»\<CR>\<BS>}")
"
"call Iab('\frame', "\begin{frame}[label=«$1»]{«$2»}\<CR>«$3»\<CR>\end{frame}")
"call Iab('\block', "\begin{block}{«$1»}\<CR>«$2»\<CR>\end{block}")
"call Iab('\onlyenv', "\begin{onlyenv}<«$1»>\<CR>«$2»\<CR>\end{onlyenv}")
"call Iab('\overlayarea', "\begin{overlayarea}{«$1:\textwidth»}{«$1»}\<CR>«$2»\<CR>\end{overlayarea}")
"call Iab('\columns', "\begin{columns}[t]\<CR>\begin{column}{«$1:0.5\textwidth»}\<CR>«$2»\<CR>\end{column}\<CR>\begin{column}{«$3:0.5\textwidth»}\<CR>«$4»\<CR>\end{column}\<CR>\end{columns}")
"call Iab('\alt', "\alt<«$1»>{«$2»}{«$3»}")
"call Iab('\alert', "\alert<«$1»>{«$2»}")
"call Iab('\only', "\only<«$1»>{«$2»}")
"call Iab('\vis', "\visible<«$1»>{«$2»}")
"call Iab('\invis', "\invisible<«$1»>{«$2»}")
"
"call Iab('\psmatrix', "\begin{psmatrix}[rowsep=«$1»,colsep=«$2»]\<CR>«$3»\<CR>\end{psmatrix}")
"
"call Iab('\eq', "\begin{equation}\<CR>«$1»\<CR>\end{equation}")
"call Iab('\eqs', "\begin{equation*}\<CR>«$1»\<CR>\end{equation*}")
"call Iab('\align', "\begin{align}\<CR>«$1»\<CR>\end{align}")
"call Iab('\aligns', "\begin{align*}\<CR>«$1»\<CR>\end{align*}")
"call Iab('\cases', "\begin{cases}\<CR>«$1» & «$2:\text{if } «$3»» \\\<CR>«$4»\<CR>\end{cases}")
"call Iab('\theorem', "\begin{theorem}\<CR>«$1»\<CR>\end{theorem}")
"call Iab('\proof', "\begin{proof}\<CR>«$1»\<CR>\end{proof}")
"
"call Iab('\tbf', "\textbf{«$1»}")
"call Iab('\ttt', "\texttt{«$1»}")
"call Iab('\tit', "\textit{«$1»}")
"
"call Iab('\figure', "\begin{figure}[ht]\<CR>\centering\<CR>«$1»\<CR>\caption{«$2»}\<CR>\label{«$3»}\<CR>\end{figure}")
"call Iab('\figures', "\begin{figure*}[ht]\<CR>\centering\<CR>«$1»\<CR>\caption{«$2»}\<CR>\label{«$3»}\<CR>\end{figure*}")
"call Iab('\icg', "\includegraphics[«$1:width=0.9\columnwidth»]{«$2»}")
"call Iab('\subfig', "\subfigure[«$1»]{\label{«$2»}«$3»}")
"call Iab('\center', "\begin{center}\<CR>«$1»\<CR>\end{center}")
"
"call Iab('\table', "\begin{table}[ht]\<CR>\centering\<CR>\begin{tabular}{«$1»}\<CR>«$2»\<CR>\end{tabular}\<CR>\end{table}")
"call Iab('\tables', "\begin{table*}[ht]\<CR>\centering\<CR>\begin{tabular}{«$1»}\<CR>«$2»\<CR>\end{tabular}\<CR>\end{table*}")
"call Iab('\tabular', "\begin{tabular}{«$1:ll»}\<CR>«$2»\<CR>\end{tabular}")
"
"call Iab('\algorithm', "\begin{algorithm}[ht]\<CR>\centering\<CR>\begin{algorithmic}[1]\<CR>«$1»\<CR>\end{algorithmic}\<CR>\end{algorithm}")
"call Iab('\algorithms', "\begin{algorithm*}[ht]\<CR>\centering\<CR>\begin{algorithmic}[1]\<CR>«$1»\<CR>\end{algorithmic}\<CR>\end{algorithm*}")
"call Iab('\algorithmic', "\begin{algorithmic}[1]\<CR>«$1»\<CR>\end{algorithmic}")
"call Iab('\listing', "\begin{lstlisting}\<CR>«$1»\<CR>\end{lstlisting}")
"
"call Iab('\tikzgraph', "\begin{tikzpicture}[node distance=«$1:1cm»]\<CR>\GraphInit[vstyle=Normal]\<CR>«$1:\Vertex[L={$1$}]{A}»\<CR>\SetUpEdge[style={<->}]\<CR>«$2»\<CR>\end{tikzpicture}")
"
"call Iab('\part', "\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\<CR>\part{«$1»}\label{«$2»}")
"call Iab('\chapt', "\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\<CR>\chapter{«$1»}\label{«$2»}")
"call Iab('\sect', "\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\<CR>\section{«$1»}\label{«$2»}")
"call Iab('\ssect', "\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\<CR>\subsection{«$1»}\label{«$2»}")
"call Iab('\sssect', "\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\%\<CR>\subsubsection{«$1»}\label{«$2»}")
