#!/bin/bash

# Syntax highliter for VIM. yes the dev-commander uses vim and create a text file called dnote (dev-note). 
# This installs the highlighting for the .dnotes keywords 

mkdir -p $HOME/.vim/ftdetect && touch $HOME/.vim/ftdetect/dnote.vim && chmod u+x $HOME/.vim/ftdetect/dnote.vim 
mkdir -p $HOME/.vim/syntax && touch $HOME/.vim/syntax/dnote.vim && chmod u+x $HOME/.vim/syntax/dnote.vim 

echo "autocmd BufRead,BufNewFile *.dnote set filetype=dnote" >> $HOME/.vim/ftdetect/dnote.vim

echo "syntax match issue \"\[ISSUE\]\"" >> $HOME/.vim/syntax/dnote.vim 
echo "syntax match url \"\[URL\]\"" >> $HOME/.vim/syntax/dnote.vim
echo "syntax match date \"\[DATE\]\"" >> $HOME/.vim/syntax/dnote.vim
echo "syntax match status \"\[STATUS\]\"" >> $HOME/.vim/syntax/dnote.vim
echo "syntax match analysis \"\[ANALYSIS\]\"" >> $HOME/.vim/syntax/dnote.vim

echo "highlight link issue Keyword" >> $HOME/.vim/syntax/dnote.vim
echo "highlight link url Keyword"  >> $HOME/.vim/syntax/dnote.vim
echo "highlight link date Keyword"  >> $HOME/.vim/syntax/dnote.vim
echo "highlight link status Keyword" >> $HOME/.vim/syntax/dnote.vim
echo "highlight link analysis Keyword" >> $HOME/.vim/syntax/dnote.vim
