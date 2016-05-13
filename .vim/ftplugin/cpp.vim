" Vim script file                                           vim600:fdm=marker:
" FileType:     cpp
" Author:       Batz

runtime! ftplugin/c.vim

call Iab('fore', "for(const auto &«$1:i» : «$2») {\<CR>«$3»\<CR>}")
call Iab('class', "class «$1» {\<CR>\<BS>private:\<CR>«$2»\<CR>\<BS>\<BS>public:\<CR>\<BS>«$3»\<CR>};")
call Iab('ns', "namespace «$1» {\<CR>«$2»\<CR>}  // namespace «$3»")
call Iab('ens', "namespace {\<CR>«$1»\<CR>}  // namespace")
call Iab('using', "using namespace «$1:std»;")
call Iab('us', "using «$1»;")

call Iab('vector', "vector<«$1:unsigned»> «$2»")
call Iab('list', "list<«$1»> «$2»")
call Iab('map', "map<«$1:string», «$2:unsigned»> «$3»")
call Iab('pair', "pair<«$1:unsigned», «$2:unsigned»> «$3»")

call Iab('ivector', "vector<«$1:unsigned»>")
call Iab('ilist', "list<«$1»>")
call Iab('imap', "map<«$1:string», «$2:unsigned»>")
call Iab('ipair', "pair<«$1:unsigned», «$2:unsigned»>")
