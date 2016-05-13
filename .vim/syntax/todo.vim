" Vim syntax file
" Adapted from
" http://ifacethoughts.net/2008/05/11/task-management-using-vim/
" Language:	Todo
" Maintainer:	Matt Spear

if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

syn keyword projTodo		TODO XXX NOTE contained

syn match projHead		"^-\s\+.*$" contains=projJump,projDate,projComp,projRecur,projRecurYear,projTag,projTodo,projReminder,projURL
syn match projTask		"^\s\+-\s\+.*" contains=projJump,projDate,projComp,projRecur,projRecurYear,projTag,projTodo,projReminder,projURL

syn match projTaskL		"^\s*-\s\+.*=low.*$" contains=projJump,projDate,projComp,projRecur,projRecurYear,projLow,projTag,projTodo,projReminder,projURL
syn match projTaskM		"^\s*-\s\+.*=med.*$" contains=projJump,projDate,projComp,projRecur,projRecurYear,projMed,projTag,projTodo,projReminder,projURL
syn match projTaskH		"^\s*-\s\+.*=high.*$" contains=projJump,projDate,projComp,projRecur,projRecurYear,projHigh,projTag,projTodo,projReminder,projURL
syn match projTaskD		"^\s*-\s\+.*=done.*$" conceal contains=projJump,projDate,projComp,projRecur,projRecurYear,projDone,projTag,projTodo,projReminder,projURL

syn match projNum		"^\s\+\d\s\+.*" contains=projJump,projDate,projComp,projRecur,projRecurYear,projTag,projTodo,projReminder,projURL
syn match projNumL		"^\s*\d\s\+.*=low.*$" contains=projJump,projDate,projComp,projRecur,projRecurYear,projLow,projTag,projTodo,projReminder,projURL
syn match projNumM		"^\s*\d\s\+.*=med.*$" contains=projJump,projDate,projComp,projRecur,projRecurYear,projMed,projTag,projTodo,projReminder,projURL
syn match projNumH		"^\s*\d\s\+.*=high.*$" contains=projJump,projDate,projComp,projRecur,projRecurYear,projHigh,projTag,projTodo,projReminder,projURL
syn match projNumD		"^\s*\d\s\+.*=done.*$" contains=projJump,projDate,projComp,projRecur,projRecurYear,projDone,projTag,projTodo,projReminder,projURL

syn match projJump		"\[[^\]]\+\]" contained
syn match projTag		"\s:[^ \t:/]\+" contained
syn match projURL		"\%(https://\|http://\|ftp://\|irc://\|file://\|www\.\)[^ \t]*" contained
syn match projURLC		"\%(https://\|http://\|ftp://\|irc://\|file://\|www\.\)[^ \t]*"

syn match projDate		"@\d\d\=/\d\d\=/\d\d\d\d\(-\d\d\=/\d\d\=/\d\d\d\d\)\=\(\s\+\d\d\=:\d\d[apAP]\(-\d\d\=:\d\d[apAP]\)\=\)\=" contained
syn match projComp		"@comp\s\+\d\d\=/\d\d\=/\d\d\d\d\s\+\d\d\=:\d\d[apAP]" contained
syn match projReminder		"@rem\s\+\d\+[dhm]" contained
syn match projRecur		"@rec\s\+[mtwrfsu]\+\(/-\=\d\d\=\(/\d\d\=\)\=\)\=\(\s\+\d\d\=:\d\d[apAP]\(-\d\d\=:\d\d[apAP]\)\=\)\=" contained
syn match projRecurYear		"@rec\s\+\d\d\=\(/\d\d\=\)\=\(\s\+\d\d\=:\d\d[apAP]\(-\d\d\=:\d\d[apAP]\)\=\)\=" contained

syn match projDone		"=done" contained
syn match projHigh		"=high" contained
syn match projMed		"=med" contained
syn match projLow		"=low" contained

hi def link projTodo		Todo
hi def link projJump		String
hi def link projTaskNote	String
hi def link projDate		Constant
hi def link projComp		Constant
hi def link projRecur		Constant
hi def link projRecurYear	Constant
hi def link projReminder	Constant
hi def link projTag		SpecialChar
hi def link projURL		Underlined
hi def link projURLC		projURL
hi def link projNum		projTask
hi def link projNumL		projTaskL
hi def link projNumM		projTaskM
hi def link projNumH		projTaskH
hi def link projNumD		projTaskD

let b:current_syntax = "todo"
