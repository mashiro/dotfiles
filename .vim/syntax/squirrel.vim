" Vim syntax file
" Language:	Squirrel
" Maintainer:	mashiro <y.mashiro@gmail.com>
" Last Change:	$Date: 2009/07/14 $
" File Types:	.nut

" Load the javaScript sytanx for now.
runtime! syntax/javascript.vim

syn keyword squirrelStatement local

hi def link squirrelStatement Statement

let b:current_syntax = "squirrel"

" vim: ts=8
