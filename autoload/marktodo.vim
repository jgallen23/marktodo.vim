
if exists("g:loaded_marktodo")
	finish
endif
let g:loaded_marktodo = 1

augroup marktodo
	" Call linemove on cursor move events in PHP files
	"autocmd CursorMoved,CursorMovedI *.md call phtmlSwitch#linemove()

	" Call linemove on opening file PHP files
	autocmd BufRead *.md call marktodo#init()
augroup END
