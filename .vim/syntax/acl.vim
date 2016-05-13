" Vim syntax file
" Language:	Acl
" Maintainer:	Matt Spear

if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

syn keyword aclTodo         TODO XXX NOTE contained
syn match   aclKey          /\<is\|in\|=\|<\|>\|startswith\|endswith\>/ contained
syn match   aclComment      "#.*" contains=aclTodo
syn match   aclEndLine      ';' contained
syn match   aclOp           "&\||" contained
syn match   aclTestSep      ',' contained
syn match   aclNum          '\d\+' contained
syn region  aclString       start=/'/ end=/'/ contained

syn region  aclTestString   start=/'/ end=/'/ contains=aclTestSep nextgroup=aclEndLine
syn keyword aclTest         tested_by nextgroup=aclTestString skipwhite skipempty contained
syn match   aclDenyMessage  '\_[^;#]\+\(tested_by\)\@=' contains=aclString nextgroup=aclTest skipwhite skipempty contained
syn keyword aclDeny         deny nextgroup=aclDenyMessage skipwhite skipempty contained
syn keyword aclPermit       permit nextgroup=aclTest skipwhite skipempty contained
syn keyword aclThen         then nextgroup=aclDeny,aclPermit skipwhite skipempty contained
syn match   aclRule         '^\s*[^#]\_[^;#]\+\(then\)\@=' contains=aclString,aclNum,aclKey,aclOp nextgroup=aclThen

syn match   aclLetRule      '=\_[^;#]\+' contains=aclKey,aclOp,aclNum,aclString nextgroup=aclEndLine contained
syn match   aclLetName      '\w[a-zA-Z0-9_-]\+' nextgroup=aclLetRule skipwhite skipempty contained
syn keyword aclLet          let nextgroup=aclLetName skipwhite skipempty

syn match   aclMsgRule      '=\_[^;#]\+' contains=aclString nextgroup=aclEndLine contained
syn match   aclMsgName      '\w[a-zA-Z0-9_-]\+' nextgroup=aclMsgRule skipwhite skipempty contained
syn keyword aclMsg          message nextgroup=aclMsgName skipwhite skipempty

hi link aclDeny            Boolean
hi link aclComment         Comment
hi link aclTestSep         Delimiter
hi link aclLetName         Identifier
hi link aclMsgName         Identifier
hi link aclTest            Keyword
hi link aclThen            Keyword
hi link aclLet             Keyword
hi link aclMsg             Keyword
hi link aclNum             Number
hi link aclKey             Operator
hi link aclOp              Operator
hi link aclEq              Operator
hi link aclEndLine         Operator
hi link aclString          String
hi link aclTestString      String
hi link aclPermit          Type

let b:current_syntax = "acl"
