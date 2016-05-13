set background=dark
hi clear
if exists("syntax_on")
	syntax reset
endif
let g:colors_name = "batz"

hi CursorColumn ctermfg=NONE ctermbg=darkgray guifg=NONE guibg=#221111 gui=NONE
hi ColorColumn ctermfg=NONE ctermbg=darkgray guifg=NONE guibg=#221111 gui=NONE
hi Comment ctermfg=green ctermbg=NONE guifg=#0CFF00 guibg=NONE gui=NONE
hi Constant ctermfg=red ctermbg=NONE guifg=#FFBAE0 guibg=NONE gui=NONE
hi Error ctermfg=NONE ctermbg=darkred guifg=NONE guibg=#770000 gui=NONE
hi FoldColumn ctermfg=cyan ctermbg=NONE guifg=#00FFFF guibg=NONE gui=bold
hi Folded ctermfg=15 ctermbg=236 guifg=#FFFFFF guibg=#222222 gui=NONE
hi Identifier ctermfg=lightred ctermbg=NONE guifg=#FFAAAA guibg=NONE gui=NONE
hi IncSearch ctermfg=black ctermbg=yellow guifg=#000000 guibg=#FFFF00 gui=NONE
hi PreProc ctermfg=cyan ctermbg=NONE guifg=#33A6FF guibg=NONE gui=NONE
hi Special ctermfg=180 ctermbg=NONE guifg=#F5C080 guibg=NONE gui=NONE
hi SpecialKey ctermfg=gray ctermbg=NONE cterm=NONE guifg=#333333 guibg=NONE gui=NONE
hi SpellBad ctermfg=NONE ctermbg=darkred guifg=NONE guibg=#550000 gui=undercurl guisp=red
hi Statement ctermfg=cyan ctermbg=NONE guifg=#00FFFF guibg=NONE gui=NONE
hi StatusLine ctermfg=black ctermbg=white guifg=#550000 guibg=#FFFFFF
hi StatusLineNC ctermfg=127 ctermbg=white guifg=#770000 guibg=NONE
hi LineNr ctermfg=yellow ctermbg=black guifg=#FFFF00 guibg=#000000
hi String ctermfg=yellow ctermbg=NONE cterm=NONE guifg=#f9ffb6 guibg=#222222 gui=NONE
hi Todo ctermfg=blue ctermbg=yellow cterm=NONE guifg=#0000FF guibg=#FFFF00 gui=NONE
hi Type ctermfg=39 guifg=#AAAAFF guibg=NONE ctermbg=NONE
hi VertSplit ctermfg=darkgray ctermbg=NONE guifg=#777777 guibg=NONE
hi Visual ctermfg=NONE ctermbg=darkblue guifg=NONE guibg=#000077
hi Normal ctermfg=white ctermbg=NONE guifg=#FFFFFF guibg=#000000 gui=NONE
hi perlDATA ctermfg=green ctermbg=NONE guifg=#7DB166 guibg=NONE gui=NONE
hi perlPOD ctermfg=green ctermbg=NONE guifg=#7DB166 guibg=NONE gui=NONE
hi perlVarPlain ctermfg=gray ctermbg=NONE guifg=#FFACAC guibg=NONE gui=NONE

" Custimization of the tabline
hi TabLineFill term=underline cterm=underline guifg=#FFFFFF guibg=#000000 gui=underline
hi TabLineSel term=bold,reverse,underline ctermfg=11 ctermbg=12 guifg=#FF7777 guibg=#000000 gui=none
hi TabLine term=underline cterm=underline ctermfg=15 ctermbg=8 guifg=#FFFFFF guibg=#000000 gui=underline

" Customization of ShowMarks
hi ShowMarksHLl guifg=#FFFFFF guibg=#000077
hi ShowMarksHLu guifg=#FFFFFF guibg=#000077
hi ShowMarksHLo guifg=#FFFFFF guibg=#000077
hi ShowMarksHLm guifg=#FFFFFF guibg=#000077

" Customize todo filetype
hi projHead guifg=#7777FF guibg=NONE gui=bold ctermfg=cyan ctermbg=NONE cterm=bold
hi projTask guifg=#FFFFFF guibg=NONE gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE
hi projTaskH guifg=#FF4444 guibg=NONE gui=NONE ctermfg=red ctermbg=NONE cterm=NONE
hi projTaskM guifg=#FFFFFF guibg=NONE gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE
hi projTaskL guifg=#AAAAAA guibg=NONE gui=NONE ctermfg=gray ctermbg=NONE cterm=NONE
hi projTaskD guifg=#444444 guibg=NONE gui=NONE ctermfg=darkgray ctermbg=NONE cterm=NONE
hi projLow guifg=#AAAAAA guibg=NONE gui=NONE ctermfg=gray ctermbg=NONE cterm=NONE
hi projMed guifg=#FFFFFF guibg=NONE gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE
hi projHigh guifg=#FF4444 guibg=NONE gui=underline ctermfg=red ctermbg=NONE cterm=underline
hi projDone guifg=#444444 guibg=NONE gui=NONE ctermfg=darkgray ctermbg=NONE cterm=NONE
hi projComp guifg=#666666 guibg=NONE gui=NONE ctermfg=darkgray ctermbg=NONE cterm=NONE
hi todocalItemPast guifg=#777777 guibg=NONE gui=NONE ctermfg=red ctermbg=NONE cterm=NONE
hi todocalItemNow guifg=#FF7777 guibg=NONE gui=NONE ctermfg=red ctermbg=NONE cterm=NONE
hi todocalItemNext guifg=#CC3333 guibg=NONE gui=NONE ctermfg=red ctermbg=NONE cterm=NONE
hi todocalItemToday guifg=#FFFF00 guibg=NONE gui=NONE ctermfg=red ctermbg=NONE cterm=NONE
