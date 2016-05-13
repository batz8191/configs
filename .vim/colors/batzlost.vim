set background=dark
hi clear
if exists("syntax_on")
	syntax reset
endif
let g:colors_name = "batz"

hi Comment ctermfg=green ctermbg=NONE guifg=#067F00 guibg=NONE gui=NONE
hi Constant ctermfg=red ctermbg=NONE guifg=#7F5D70 guibg=NONE gui=NONE
hi Error ctermfg=NONE ctermbg=darkred guifg=NONE guibg=#3B0000 gui=NONE
hi FoldColumn ctermfg=cyan ctermbg=NONE guifg=#007F7F guibg=NONE gui=bold
hi Folded ctermfg=15 ctermbg=236 guifg=#7F7F7F guibg=#111111 gui=NONE
hi Identifier ctermfg=lightred ctermbg=NONE guifg=#7F5555 guibg=NONE gui=NONE
hi IncSearch ctermfg=black ctermbg=yellow guifg=#000000 guibg=#7F7F00 gui=NONE
hi PreProc ctermfg=cyan ctermbg=NONE guifg=#19537F guibg=NONE gui=NONE
hi Special ctermfg=180 ctermbg=NONE guifg=#7A6040 guibg=NONE gui=NONE
hi SpecialKey ctermfg=gray ctermbg=NONE cterm=NONE guifg=#191919 guibg=NONE gui=NONE
hi SpellBad ctermfg=NONE ctermbg=darkred guifg=NONE guibg=#2A0000 gui=undercurl guisp=red
hi Statement ctermfg=cyan ctermbg=NONE guifg=#007F7F guibg=NONE gui=NONE
hi StatusLine ctermfg=black ctermbg=white guifg=#2A0000 guibg=#7F7F7F
hi StatusLineNC ctermfg=127 ctermbg=white guifg=#3B0000 guibg=NONE
hi LineNr ctermfg=yellow ctermbg=black guifg=#7F7F00 guibg=#000000
hi String ctermfg=yellow ctermbg=NONE cterm=NONE guifg=#7C7F5B guibg=#111111 gui=NONE
hi Todo ctermfg=blue ctermbg=yellow cterm=NONE guifg=#00007F guibg=#7F7F00 gui=NONE
hi Type ctermfg=39 guifg=#55557F guibg=NONE ctermbg=NONE
hi VertSplit ctermfg=darkgray ctermbg=NONE guifg=#3B3B3B guibg=NONE
hi Visual ctermfg=NONE ctermbg=darkblue guifg=NONE guibg=#00003B
hi Normal ctermfg=white ctermbg=NONE guifg=#7F7F7F guibg=#000000 gui=NONE
hi perlDATA ctermfg=green ctermbg=NONE guifg=#3E5833 guibg=NONE gui=NONE
hi perlPOD ctermfg=green ctermbg=NONE guifg=#3E5833 guibg=NONE gui=NONE
hi perlVarPlain ctermfg=gray ctermbg=NONE guifg=#7F5656 guibg=NONE gui=NONE

" Custimization of the tabline
hi TabLineFill term=underline cterm=underline guifg=#7F0000 guibg=#000000 gui=underline
hi TabLineSel term=bold,reverse,underline ctermfg=11 ctermbg=12 guifg=#7F7F7F guibg=#000000 gui=none
hi TabLine term=underline cterm=underline ctermfg=15 ctermbg=8 guifg=#7F7F7F guibg=#000000 gui=underline

" Customization of ShowMarks
hi ShowMarksHLl guifg=#7F7F7F guibg=#00003B
hi ShowMarksHLu guifg=#7F7F7F guibg=#00003B
hi ShowMarksHLo guifg=#7F7F7F guibg=#00003B
hi ShowMarksHLm guifg=#7F7F7F guibg=#00003B

" Customize todo filetype
hi projHead guifg=#3B3B7F guibg=NONE gui=bold ctermfg=cyan ctermbg=NONE cterm=bold
hi projTagL guifg=#555555 guibg=NONE gui=bold ctermfg=gray ctermbg=NONE cterm=bold
hi projTagM guifg=#3B3B7F guibg=NONE gui=bold ctermfg=NONE ctermbg=NONE cterm=bold
hi projTagH guifg=#7F1111 guibg=NONE gui=bold ctermfg=red ctermbg=NONE cterm=bold
hi projTagD guifg=#222222 guibg=NONE gui=bold ctermfg=darkgray ctermbg=NONE cterm=bold
hi projLow guifg=#555555 guibg=NONE gui=NONE ctermfg=gray ctermbg=NONE cterm=NONE
hi projMed guifg=#7F7F7F guibg=NONE gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE
hi projHigh guifg=#7F1111 guibg=NONE gui=underline ctermfg=red ctermbg=NONE cterm=underline
hi projDone guifg=#222222 guibg=NONE gui=NONE ctermfg=darkgray ctermbg=NONE cterm=NONE
hi projTaskD guifg=#222222 guibg=NONE gui=NONE ctermfg=darkgray ctermbg=NONE cterm=NONE
hi projTaskL guifg=#555555 guibg=NONE gui=NONE ctermfg=gray ctermbg=NONE cterm=NONE
hi projTaskM guifg=#7F7F7F guibg=NONE gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE
hi projTask guifg=#7F7F7F guibg=NONE gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE
hi projTaskH guifg=#7F1111 guibg=NONE gui=NONE ctermfg=red ctermbg=NONE cterm=NONE
