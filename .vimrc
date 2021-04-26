" - - - - - vim-plug - - - - - 

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle') 

" sensible.vim
" Common defaults for vimrc
Plug 'tpope/vim-sensible'

" fugitive.vim
" git wrapper
Plug 'tpope/vim-fugitive'

" vim-ansible-yaml
" Adds additional syntax highlighting and fixes indention for YAML
Plug 'chase/vim-ansible-yaml'

" vim-plug
" help documents for vim-plug 
Plug 'junegunn/vim-plug' 

" vim-xmark 
" opens browser window to display markdown preview
Plug 'junegunn/vim-xmark', { 'do': 'make' } 

" vim-gitgutter
" Show gitstatus in the 'gutter'
Plug 'airblade/vim-gitgutter'

" vim-scala
" Add scala support to vim
Plug 'derekwyatt/vim-scala'

call plug#end()


" - - - - - mappings - - - - -

" quickly exit insert/view modes
inoremap jk <esc>

" - - - - - finding files - - - - -

set path+=** 

" - - - - - tags - - - - -

command! MakeTags !ctags -R .  

" - - - - - settings - - - - - 

set nocompatible
syntax enable 
filetype plugin on

" editor settings
set number

" format settings
set tabstop=4 
au filetype yaml setlocal ts=2 sw=2 expandtab
au filetype json setlocal ts=4 sw=4 expandtab
au filetype vim setlocal ts=2 sw=2 expandtab

" statusline 
set statusline=
set statusline+=%f
set statusline+=\ %y 
set statusline+=\ %{fugitive#statusline()}
set statusline+=%= " switch to right side
set statusline+=%l
set statusline+=/
set statusline+=%L
hi statusline ctermbg=blue ctermfg=black 
