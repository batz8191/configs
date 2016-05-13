setl ts=2
setl sw=2
setl et

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <buffer> <silent> <localleader>s :call NormalToScreen()<CR>
vmap <buffer> <silent> <localleader>s :call SendToScreen()<CR>
nmap <buffer> <silent> <localleader>v :call ScreenVars()<CR>
