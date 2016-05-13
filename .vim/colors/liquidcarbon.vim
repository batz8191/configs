" File: liquidcarbon.vim
" Author: Jeet Sukumaran
" Description: Vim color file
" Last Modified: October 06, 2010

" Initialization and Setup {{{1
" ============================================================================
set background=dark
highlight clear
if exists("syntax_on")
	syntax reset
endif
let colors_name = "liquidcarbon"
" 1}}}

" Normal Color {{{1
" ============================================================================
hi Normal           guifg=#bdcdcd   guibg=#000000   gui=NONE         ctermfg=251  ctermbg=NONE cterm=NONE
hi CursorLine       guifg=NONE      guibg=#333333   gui=NONE         ctermfg=NONE ctermbg=236  cterm=NONE
hi CursorColumn     guifg=NONE      guibg=#333333   gui=NONE         ctermfg=NONE ctermbg=236  cterm=NONE
hi ColorColumn      guifg=NONE      guibg=#221111   gui=NONE         ctermfg=NONE ctermbg=233  cterm=NONE
" 1}}}

" Core Highlights {{{1
" ============================================================================
hi Cursor           guifg=bg        guibg=fg        gui=NONE         ctermfg=16   ctermbg=251  cterm=NONE
hi CursorIM         guifg=bg        guibg=fg        gui=NONE         ctermfg=16   ctermbg=251  cterm=NONE
hi lCursor          guifg=bg        guibg=fg        gui=NONE         ctermfg=16   ctermbg=251  cterm=NONE
hi Directory        guifg=#1e90ff   guibg=bg        gui=NONE         ctermfg=33   ctermbg=NONE cterm=NONE
hi ErrorMsg         guifg=#ff6a6a   guibg=NONE      gui=bold         ctermfg=203  ctermbg=NONE cterm=bold
hi FoldColumn       guifg=#68838b   guibg=#4B4B4B   gui=bold         ctermfg=66   ctermbg=NONE cterm=bold
hi Folded           guifg=#68838b   guibg=#4B4B4B   gui=NONE         ctermfg=66   ctermbg=NONE cterm=NONE
hi IncSearch        guifg=#ffffff   guibg=#878700   gui=bold         ctermfg=231  ctermbg=100  cterm=bold
"hi LineNr           guifg=#acac00   guibg=#202020   gui=NONE         ctermfg=142  ctermbg=16   cterm=NONE
"hi LineNr           guifg=#555500   guibg=#000000   gui=NONE         ctermfg=142  ctermbg=16   cterm=NONE
hi LineNr           guifg=#767676   guibg=#050505   gui=NONE         ctermfg=142  ctermbg=16   cterm=NONE
hi MatchParen       guifg=#ffff00   guibg=#000000   gui=bold         ctermfg=226  ctermbg=16   cterm=bold
hi ModeMsg          guifg=#007700   guibg=#000000   gui=bold         ctermfg=28   ctermbg=16   cterm=bold
hi MoreMsg          guifg=#2e8b57   guibg=bg        gui=bold         ctermfg=29   ctermbg=NONE cterm=bold
hi NonText          guifg=#9ac0cd   guibg=bg        gui=NONE         ctermfg=109  ctermbg=NONE cterm=NONE
hi Pmenu            guifg=#bdcdc9   guibg=#444444   gui=bold         ctermfg=251  ctermbg=238  cterm=bold
hi PmenuSel         guifg=#c0c8cf   guibg=#000077   gui=bold         ctermfg=251  ctermbg=18   cterm=bold
hi PmenuSbar        guifg=#ffffff   guibg=#c1cdc1   gui=NONE         ctermfg=231  ctermbg=251  cterm=NONE
hi PmenuThumb       guifg=#ffffff   guibg=#838b83   gui=NONE         ctermfg=231  ctermbg=245  cterm=NONE
hi Question         guifg=#00ee00   guibg=NONE      gui=bold         ctermfg=46   ctermbg=NONE cterm=bold
hi Search           guifg=#000000   guibg=#878700   gui=bold         ctermfg=16   ctermbg=100  cterm=bold
hi SignColumn       guifg=#ffffff   guibg=#cdcdb4   gui=NONE         ctermfg=231  ctermbg=187  cterm=NONE
hi SpecialKey       guifg=#666666   guibg=NONE      gui=NONE         ctermfg=241  ctermbg=NONE cterm=NONE
hi SpellBad         guibg=NONE      guisp=#ff0000   gui=undercurl    ctermfg=NONE ctermbg=196  cterm=NONE
hi SpellCap         guibg=NONE      guisp=#0000ff   gui=undercurl    ctermfg=NONE ctermbg=21   cterm=NONE
hi SpellLocal       guibg=NONE      guisp=#00ffff   gui=undercurl    ctermfg=NONE ctermbg=51   cterm=NONE
hi SpellRare        guibg=NONE      guisp=#ff00ff   gui=undercurl    ctermfg=NONE ctermbg=201  cterm=NONE
hi StatusLine       guifg=#ddeeff   guibg=#112233   gui=NONE         ctermfg=255  ctermbg=234  cterm=NONE
"hi StatusLineNC     guifg=#999999   guibg=#556677   gui=italic       ctermfg=247  ctermbg=241  cterm=italic
hi StatusLineNC     guifg=#7a8a8a   guibg=#333333   gui=italic       ctermfg=102  ctermbg=236  cterm=italic
hi TabLineFill      guifg=#bdcdcd   guibg=#000000   gui=underline    ctermfg=251  ctermbg=16   cterm=underline
hi TabLineSel       guifg=#bdcdcd   guibg=#000000   gui=none         ctermfg=251  ctermbg=16   cterm=none
hi TabLine          guifg=#7a8a8a   guibg=#333333   gui=underline    ctermfg=102  ctermbg=236  cterm=underline
hi Title            guifg=#009acd   guibg=bg        gui=bold         ctermfg=31   ctermbg=NONE cterm=bold
hi VertSplit        guifg=#445566   guibg=#445566   gui=NONE         ctermfg=240  ctermbg=240  cterm=NONE
hi Visual           guifg=#000000   guibg=#3055aa   gui=NONE         ctermfg=16   ctermbg=25   cterm=NONE
hi WarningMsg       guifg=#ee9a00   guibg=bg        gui=NONE         ctermfg=172  ctermbg=NONE cterm=NONE
hi WildMenu         guifg=#000000   guibg=#87ceeb   gui=NONE         ctermfg=16   ctermbg=117  cterm=NONE

" 1}}}

" Syntax {{{1
" ============================================================================

"  General {{{2
" -----------------------------------------------------------------------------
hi Comment          guifg=#309030   guibg=NONE      gui=NONE         ctermfg=28   ctermbg=NONE cterm=NONE
hi Constant         guifg=#cdad00   guibg=NONE      gui=NONE         ctermfg=178  ctermbg=NONE cterm=NONE
hi String           guifg=#cccc66   guibg=#222222   gui=NONE         ctermfg=185  ctermbg=235  cterm=NONE
hi Boolean          guifg=#cd69c9   guibg=NONE      gui=NONE         ctermfg=133  ctermbg=NONE cterm=NONE
hi Identifier       guifg=#9f79ee   guibg=NONE      gui=NONE         ctermfg=141  ctermbg=NONE cterm=NONE
"hi Function         guifg=#92a5de   guibg=NONE      gui=NONE         ctermfg=146  ctermbg=NONE cterm=NONE
hi Function         guifg=#f0c674   guibg=NONE      gui=NONE         ctermfg=215  ctermbg=NONE cterm=NONE
hi Statement        guifg=#009acd   guibg=NONE      gui=NONE         ctermfg=31   ctermbg=NONE cterm=NONE
"hi PreProc          guifg=#009acd   guibg=NONE      gui=NONE         ctermfg=31   ctermbg=NONE cterm=NONE
hi PreProc          guifg=#8abeb7   guibg=NONE      gui=NONE         ctermfg=44   ctermbg=NONE cterm=NONE
hi Keyword          guifg=#7ac5cd   guibg=NONE      gui=NONE         ctermfg=116  ctermbg=NONE cterm=NONE
hi Structure        guifg=#8abeb7   guibg=NONE      gui=NONE         ctermfg=44   ctermbg=NONE cterm=NONE
"hi Type             guifg=#4169e1   guibg=NONE      gui=NONE         ctermfg=26   ctermbg=NONE cterm=NONE
hi Type             guifg=#de935f   guibg=NONE      gui=NONE         ctermfg=178   ctermbg=NONE cterm=NONE
hi Special          guifg=#7f9f44   guibg=NONE      gui=NONE         ctermfg=107  ctermbg=NONE cterm=NONE
hi Ignore           guifg=bg        guibg=NONE      gui=NONE         ctermfg=16   ctermbg=NONE cterm=NONE
hi Error            guifg=#ff3030   guibg=NONE      gui=underline    ctermfg=160  ctermbg=NONE cterm=underline
hi Todo             guifg=#ff88ee   guibg=NONE      gui=bold         ctermfg=213  ctermbg=NONE cterm=bold

" 2}}}

" Vim {{{2
" -----------------------------------------------------------------------------
hi VimError         guifg=#ff0000   guibg=#000000   gui=bold        ctermfg=196  ctermbg=16   cterm=bold
hi VimCommentTitle  guifg=#528b8b   guibg=bg        gui=bold,italic ctermfg=66   ctermbg=NONE cterm=bold
" 2}}}

" QuickFix {{{2
" -----------------------------------------------------------------------------
hi qfFileName       guifg=#607b8b   guibg=NONE      gui=italic      ctermfg=66   ctermbg=NONE cterm=italic
hi qfLineNr         guifg=#0088aa   guibg=NONE      gui=bold        ctermfg=31   ctermbg=NONE cterm=bold
hi qfError          guifg=#ff0000   guibg=NONE      gui=bold        ctermfg=196  ctermbg=NONE cterm=bold
" 2}}}

" Python {{{2
" -----------------------------------------------------------------------------
hi pythonDecorator  guifg=#cd8500   guibg=NONE      gui=NONE        ctermfg=172  ctermbg=NONE cterm=NONE
hi link pythonDecoratorFunction pythonDecorator
" 2}}}

" Perl {{{2
" -----------------------------------------------------------------------------
hi perlVarPlain     guifg=fg        guibg=NONE      gui=NONE        ctermfg=fg   ctermbg=NONE cterm=NONE
hi perlDATA         guifg=#489030   guibg=NONE      gui=NONE        ctermfg=71   ctermbg=NONE cterm=NONE
hi perlPOD          guifg=#489030   guibg=NONE      gui=NONE        ctermfg=71   ctermbg=NONE cterm=NONE
hi podCommand       guifg=#48aa30   guibg=NONE      gui=NONE        ctermfg=28   ctermbg=NONE cterm=NONE
hi perlSharpBang    guifg=#6666cc   guibg=NONE      gui=bold,italic ctermfg=62   ctermbg=NONE cterm=bold
hi link perlVarPlain2 perlVarPlain
hi link perlStatementInclude Include
" 2}}}

" Todo {{{2
" -----------------------------------------------------------------------------
hi projHead         guifg=#8733FF   guibg=NONE      gui=bold        ctermfg=99   ctermbg=NONE cterm=bold
hi projTask         guifg=fg        guibg=NONE      gui=NONE        ctermfg=fg   ctermbg=NONE cterm=NONE
hi projTaskH        guifg=#FF3030   guibg=NONE      gui=NONE        ctermfg=203  ctermbg=NONE cterm=NONE
hi projTaskM        guifg=fg        guibg=NONE      gui=NONE        ctermfg=fg   ctermbg=NONE cterm=NONE
hi projTaskL        guifg=#888888   guibg=NONE      gui=NONE        ctermfg=245  ctermbg=NONE cterm=NONE
hi projTaskD        guifg=#444444   guibg=NONE      gui=NONE        ctermfg=238  ctermbg=NONE cterm=NONE
hi projLow          guifg=#888888   guibg=NONE      gui=NONE        ctermfg=245  ctermbg=NONE cterm=NONE
hi projMed          guifg=fg        guibg=NONE      gui=NONE        ctermfg=fg   ctermbg=NONE cterm=NONE
hi projHigh         guifg=#FF3030   guibg=NONE      gui=underline   ctermfg=203  ctermbg=NONE cterm=underline
hi projDone         guifg=#444444   guibg=NONE      gui=NONE        ctermfg=238  ctermbg=NONE cterm=NONE
hi projComp         guifg=#666666   guibg=NONE      gui=NONE        ctermfg=238  ctermbg=NONE cterm=NONE
hi todocalItemPast  guifg=#777777   guibg=NONE      gui=NONE        ctermfg=203  ctermbg=NONE cterm=NONE
hi todocalItemNow   guifg=#FF7777   guibg=NONE      gui=NONE        ctermfg=203  ctermbg=NONE cterm=NONE
hi todocalItemNext  guifg=#CC3333   guibg=NONE      gui=NONE        ctermfg=203  ctermbg=NONE cterm=NONE
hi todocalItemToday guifg=#FFFF00   guibg=NONE      gui=NONE        ctermfg=203  ctermbg=NONE cterm=NONE
" 2}}}

" Diff {{{2
" -----------------------------------------------------------------------------
hi DiffAdd          guifg=NONE      guibg=#000055   gui=NONE        ctermfg=NONE ctermbg=238   cterm=NONE
hi DiffChange       guifg=NONE      guibg=#b33b71   gui=NONE        ctermfg=NONE ctermbg=52    cterm=NONE
hi DiffDelete       guifg=NONE      guibg=#8b3626   gui=NONE        ctermfg=NONE ctermbg=52    cterm=NONE
hi DiffText         guifg=NONE      guibg=#ff5f00   gui=NONE        ctermfg=NONE ctermbg=238   cterm=NONE
hi diffOldFile      guifg=#da70d6   guibg=NONE      gui=italic      ctermfg=55   ctermbg=NONE cterm=italic
hi diffNewFile      guifg=#ffff00   guibg=NONE      gui=italic      ctermfg=60   ctermbg=NONE cterm=italic
hi diffFile         guifg=#ffa500   guibg=NONE      gui=italic      ctermfg=68   ctermbg=NONE cterm=italic
hi diffLine         guifg=#ff00ff   guibg=NONE      gui=italic      ctermfg=69   ctermbg=NONE cterm=italic
hi diffRemoved      guifg=#cd5555   guibg=NONE      gui=NONE        ctermfg=64   ctermbg=NONE cterm=NONE
hi diffChanged      guifg=#4f94cd   guibg=NONE      gui=NONE        ctermfg=59   ctermbg=NONE cterm=NONE
hi diffAdded        guifg=#00cd00   guibg=NONE      gui=NONE        ctermfg=40   ctermbg=NONE cterm=NONE
hi link             diffOnly        Constant
hi link             diffIdentical   Constant
hi link             diffDiffer      Constant
hi link             diffBDiffer     Constant
hi link             diffIsA         Constant
hi link             diffNoEOL       Constant
hi link             diffCommon      Constant
hi link             diffSubname     diffLine
hi link             diffComment     Comment
" 2}}}

" 1}}}

" vim:foldmethod=marker
