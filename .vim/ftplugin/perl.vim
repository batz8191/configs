" Vim script file                                           vim600:fdm=marker:
" FileType:     perl
" Author:       Batz

setlocal keywordprg=perldoc
setlocal makeprg=perl\ /usr/share/vim/vim72/tools/efm_perl.pl\ -c\ %\ $*
setlocal errorformat=%f:%l:%m
setlocal nolbr

let g:perl_fold = 1
let g:perl_fold_blocks = 1
let g:perl_include_pod = 1
let g:perl_extended_vars = 1

map <silent> <buffer> <F1> :call MyPerldoc()<CR>gg
imap <silent> <buffer> <F1> <ESC>:call MyPerldoc()<CR>gg
map <silent> <buffer> <S-F10> :set makeprg=perl\ /usr/share/vim/vim72/tools/efm_perl.pl\ %\ $*<CR>:Make<CR>:set makeprg=perl\ /usr/share/vim/vim72/tools/efm_perl.pl\ -c\ %\ $*<CR>:copen<CR><C-W>L<C-W>h
imap <silent> <buffer> <S-F10> <ESC>:set makeprg=perl\ /usr/share/vim/vim72/tools/efm_perl.pl\ %\ $*<CR>:Make<CR>:set makeprg=perl\ /usr/share/vim/vim72/tools/efm_perl.pl\ -c\ %\ $*<CR>:copen<CR><C-W>L<C-W>hi

vmap <silent> <buffer> ;if <ESC>'<Oif()<CR>{<Esc>'>o}<Esc>%v%=kf(a
vmap <silent> <buffer> ;unless <ESC>'<Ounless()<CR>{<Esc>'>o}<Esc>%v%=kf(a
vmap <silent> <buffer> ;for <ESC>'<Ofor ()<CR>{<Esc>'>o}<Esc>%v%=kf(a
vmap <silent> <buffer> ;fori <ESC>'<Ofor(my )<CR>{<Esc>'>o}<Esc>%v%=kf a
vmap <silent> <buffer> ;fore <ESC>'<Oforeach ()<CR>{<Esc>'>o}<Esc>%v%=kf(a
vmap <silent> <buffer> ;while <ESC>'<Owhile()<CR>{<Esc>'>o}<Esc>%v%=kf(a
vmap <silent> <buffer> ;until <ESC>'<Ountil()<CR>{<Esc>'>o}<Esc>%v%=kf(a

call Iab('#!', "#!/usr/bin/perl\<CR>«$1»")

call Iab('uses', "use strict;\<CR>use warnings;\<CR>use v5.12;\<CR>«$1»")

call Iab('eval', "eval { «$1» };")

call Iab('for', "for «$1:my $i»(«$2»)\<CR>{\<CR>«$3»\<CR>}")
call Iab('fore', "foreach «$1:my $i»(@«$2:a»)\<CR>{\<CR>«$3»\<CR>}")
call Iab('fori', "for(«$1:my $i = 0»; «$2:$i < «$3»»; «$4:++$i»)\<CR>{\<CR>«$5»\<CR>}")

call Iab('iif', "«$1» if «$2»;")
call Iab('iunless', "«$1» unless «$3»;")

call Iab('if', "if(«$1»)\<CR>{\<CR>«$2»\<CR>}")
call Iab('ife', "if(«$1»)\<CR>{\<CR>«$3»\<CR>}\<CR>else\<CR>{\<CR>«$4»\<CR>}")
call Iab('ifel', "if(«$1»)\<CR>{\<CR>«$2»\<CR>}\<CR>elsif(«$3»)\<CR>{\<CR>«$4»\<CR>}")

call Iab('sub', "sub «$1»\<CR>{\<CR>my («$2») = @_;\<CR>«$3»\<CR>}")
call Iab('csub', "sub «$1»\<CR>{\<CR>my ($self, «$2») = @_;\<CR>«$3»\<CR>}")

call Iab('unless', "unless(«$1»)\<CR>{\<CR>«$2»\<CR>}")
call Iab('while', "while(«$1»)\<CR>{\<CR>«$2»\<CR>}")
call Iab('until', "until(«$1»)\<CR>{\<CR>«$2»\<CR>}")

call Iab('do', "do\<CR>{\<CR>«$1»\<CR>}")

call Iab('class', "package «$1»;\<CR>use base qw/«$2»/;\<CR>\<CR>sub new\<CR>{\<CR>my ($cls, «$3:@args») = @_;\<CR>my $self = {\<CR>«$4»\<CR>};\<CR>$self = bless($self, $cls);\<CR>return $self;\<CR>}")

call Iab('rfile', "open(F, «$1») or die \"«$2:Cannot open «$3».\\n»\";\<CR>while(<F>)\<CR>{\<CR>chomp;\<CR>«$3»\<CR>}\<CR>close(F);")

" execute Perldoc and place it in a new vertical split
function! MyPerldoc()
	let temp=expand("<cword>")
	vert new
	exec "r !perldoc " . temp
endfunction
