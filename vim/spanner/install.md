# Install
## Add files to:

```sh
~/.vim/syntax/spanner.vim 
~/.vim/dict/spanner.txt
```

## Update

```
~/.vimrc
```

## vimrc Example
```
set nocompatible
filetype off

" Force .sql files to use spanner filetype
augroup SpannerSetup
  autocmd!
  autocmd BufNewFile,BufRead *.sql,*.spanner,*.spanner.sql set filetype=spanner
  autocmd FileType spanner autocmd TextChangedI <buffer> call SpannerAutoComplete()
augroup END

filetype plugin indent on
syntax enable

" Ensure colors work properly in macOS Terminal / iTerm2
if !has('gui_running') && &term =~ '^\%(screen\|tmux\)'
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
set background=dark

function! SpannerAutoComplete()
  if pumvisible()
    return
  endif
  let l:col = col('.') - 1
  let l:line = getline('.')
  if l:col >= 2 && l:line[l:col - 2 : l:col - 1] =~# '\k\{2}'
    call feedkeys("\<C-n>", 'n')
  endif
endfunction
```
