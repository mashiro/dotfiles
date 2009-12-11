" Vim syn file
" Language:		Squirrel
" Maintainer:	mashiro <y.mashiro@gmail.com>
" Last Change:	2009/12/11

" Quit when a syntax file was already loaded
if exists("b:current_syntax")
	finish
endif

" Read the javascript syntax to start with
runtime! syntax/javascript.vim
unlet b:current_syntax

" Keyword definitions
syn keyword sqRepeat			foreach
syn keyword sqStorageClass		local
syn keyword sqStorageClass		static
syn keyword sqStatement			clone
syn keyword sqStatement			delegate
syn keyword sqStatement			resume
syn keyword sqStatement			this
syn keyword sqStatement			parent
syn keyword sqStatement			yield
syn keyword sqFunction			constructor

" Define the default highlighting
hi def link sqRepeat			Repeat
hi def link sqStorageClass		StorageClass
hi def link sqStatement			Statement
hi def link sqFunction			Function

let b:current_syntax = "squirrel"
