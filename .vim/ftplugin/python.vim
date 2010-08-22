setl autoindent
setl smartindent cinwords=if,elif,else,for,while,with,try,except,finally,def,class
setl tabstop=4
setl shiftwidth=4
setl softtabstop=4

if filereadable(expand('~/.vim/ftplugin/python_fold.vim'))
	source ~/.vim/ftplugin/python_fold.vim
endif
