" Wikipedia syntax file for Vim
" Published on Wikipedia in 2003-04 and declared authorless.
" 
" Based on the HTML syntax file. Probably too closely based, in fact. There
" may well be name collisions everywhere, but ignorance is bliss, so they say.
"
" To do: plug-in support for downloading and uploading to the server.

syntax clear
syn spell toplevel

" Special
syn match wikiSpecialChar "\\[$&%#{}_]"
syn match htmlSpecialChar "&#\=[0-9A-Za-z]\{1,8};"
syn match texSpecialChar "&[^a-zA-Z0-9#]\|\\\\"
syn keyword wikiTodo	TODO XXX NOTE
hi link texSpecialChar Constant

" HI
syn region wikiH1 start="==" end="==" oneline contains=@Spell,wikilink,wikiInlineMath
syn region wikiH2 start="===" end="===" oneline contains=@Spell,wikilink,wikiInlineMath
syn region wikiH3 start="====" end="====" oneline contains=@Spell,wikilink,wikiInlineMath
syn region wikiH4 start="=====" end="=====" oneline contains=@Spell,wikilink,wikiInlineMath
syn region wikiH5 start="======" end="======" oneline contains=@Spell,wikilink,wikiInlineMath
syn region wikiH6 start="=======" end="======" oneline contains=@Spell,wikilink,wikiInlineMath

" icode
syn region wikiInlineCode start="C<" end=">" contains=@Spell,wikilink

" ul, ol
syn match wikiListStart "^[\*#]\+"

" Begin/end
syn match wikiBE "\\begin\>\|\\end\>" nextgroup=wikiSection
syn region wikiSection matchgroup=Delimiter start="{" end="}" contained

" links
syn region wikiLink start="\[\[" end="\]\]"
syn region wikiILink start="((" end="))"
syn region wikiImg start="{{" end="}}"

" special \ strings
syn match wikiBackslash "\\\(Backslash\|!\)"
syn match wikiRef "\\\(label\|ref\|eqref\)" nextgroup=wikiSection

" biu
syn region wikiBold start="''" end="''"
syn region wikiItalic start="//" end="//"
syn region wikiUnderline start="__" end="__"

" tags
syn match wikiTag "^{[^{}]\+}"
hi link wikiTag String

" Code
function! TextEnableCodeSnip(filetype,start,end,textSnipHl) abort
	let ft=toupper(a:filetype)
	let group=ft
	if exists('b:current_syntax')
		let s:current_syntax=b:current_syntax
		" Remove current syntax definition, as some syntax files (e.g. cpp.vim)
		" do nothing if b:current_syntax is defined.
		unlet b:current_syntax
	endif
	execute 'syntax include @' . group . ' syntax/' . a:filetype . '.vim'
	try
		execute 'syntax include @' . group . ' after/syntax/' . a:filetype . '.vim'
	catch
	endtry
	if exists('s:current_syntax')
		let b:current_syntax=s:current_syntax
	else
		unlet b:current_syntax
	endif
	execute 'syntax region textSnip' . ft . ' matchgroup=' . a:textSnipHl
		\ . ' start="' . a:start . '" end="' . a:end
		\ . '" contains=@' . group . ""
endfunction

call TextEnableCodeSnip('perl', '\\begin{code}{perl}', '\\end{code}', 'wikiCode')
call TextEnableCodeSnip('cpp', '\\begin{code}{cpp}', '\\end{code}', 'wikiCode')
syn region wikiOtherCode matchgroup=wikiCode start="\\begin{code}{}" end="\\end{code}"

" Math
" Largely from tex.vim
syn include @TEX syntax/tex.vim
syn region wikiInlineMath matchgroup=Delimiter start="\$" skip="\\\\\|\\\$" matchgroup=Delimiter end="\$" end="%stopzone\>" contains=@texMathZoneGroup
syn region wikiDelimMath matchgroup=Delimiter start="\\\[" matchgroup=Delimiter end="\\]\|%stopzone\>" keepend contains=@texMathZoneGroup
fun! TexNewMathZone(sfx,mathzone,starform)
	let grpname  = "texMathZone".a:sfx
	let syncname = "texSyncMathZone".a:sfx
	if g:tex_fold_enabled
		let foldcmd= " fold"
	else
		let foldcmd= ""
	endif
	exe "syn cluster texMathZones add=".grpname
	exe 'syn region '.grpname.' start='."'".'\\begin\s*{\s*'.a:mathzone.'\s*}'."'".' end='."'".'\\end\s*{\s*'.a:mathzone.'\s*}'."'".' keepend contains=@texMathZoneGroup'.foldcmd
	exe 'syn sync match '.syncname.' grouphere '.grpname.' "\\begin\s*{\s*'.a:mathzone.'\*\s*}"'
	exe 'syn sync match '.syncname.' grouphere '.grpname.' "\\begin\s*{\s*'.a:mathzone.'\*\s*}"'
	exe 'hi def link '.grpname.' wikiMath'
	if a:starform
		let grpname  = "texMathZone".a:sfx.'S'
		let syncname = "texSyncMathZone".a:sfx.'S'
		exe "syn cluster texMathZones add=".grpname
		exe 'syn region '.grpname.' start='."'".'\\begin\s*{\s*'.a:mathzone.'\*\s*}'."'".' end='."'".'\\end\s*{\s*'.a:mathzone.'\*\s*}'."'".' keepend contains=@texMathZoneGroup'.foldcmd
		exe 'syn sync match '.syncname.' grouphere '.grpname.' "\\begin\s*{\s*'.a:mathzone.'\*\s*}"'
		exe 'syn sync match '.syncname.' grouphere '.grpname.' "\\begin\s*{\s*'.a:mathzone.'\*\s*}"'
		exe 'hi def link '.grpname.' wikiMath'
	endif
endfun
call TexNewMathZone("A","align",1)
call TexNewMathZone("E","equation",1)

hi link wikiH1 Title
hi link wikiH2 Title
hi link wikiH3 Title
hi link wikiH4 Title
hi link wikiH5 Title
hi link wikiH6 Title
hi link htmlSpecialChar Special
hi link wikiTodo Todo
hi link wikiInlineCode String
hi link wikiQuote String
hi link wikiListStart Constant
hi link wikiBackslash Statement
hi link wikiRef Statement
hi link wikiBE Statement
hi link wikiSection PreCondit
hi link wikiLink Underlined
hi link wikiILink Underlined
hi link wikiImg Underlined
hi wikiBold term=bold cterm=bold gui=bold
hi wikiItalic term=italic cterm=italic gui=italic
hi wikiUnderline term=underline cterm=underline gui=underline

let b:current_syntax = "wiki"
