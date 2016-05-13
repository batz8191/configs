" Vim syntax file
" Language:	Todo
" Maintainer:	Matt Spear

if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

syn match todocalItemPastMarker		"\*" conceal contained
syn match todocalItemNowMarker		"%" conceal contained
syn match todocalItemNextMarker		"\^" conceal contained
syn match todocalItemTodayMarker	"@" conceal contained

syn match todocalItemPast		"\*[ /0-9]\+\*" contains=todocalItemPastMarker
syn match todocalItemNow		"%[ /0-9]\+%" contains=todocalItemNowMarker
syn match todocalItemNext		"\^[ /0-9]\+\^" contains=todocalItemNextMarker
syn match todocalItemToday		"@[ /0-9]\+@" contains=todocalItemTodayMarker
syn match todocalEndSpaces		"\s\+$" conceal

hi def link todocalItemPastMarker Ignore
hi def link todocalItemNowMarker Ignore
hi def link todocalItemNextMarker Ignore
hi def link todocalItemTodayMarker Ignore
hi def link todocalEndSpaces Ignore

let b:current_syntax = "todo"
