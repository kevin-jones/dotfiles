execute pathogen#infect()
" Change mapleader
let mapleader=","
let g:ctrlp_map = '<leader>t'
let g:ctrlp_max_files=0
let g:ctrlp_max_depth=40
imapclear
abclear

" RELOAD VIMRC across all windows/tabs
nnoremap <leader>v :tabdo source $MYVIMRC<CR>

" Show recent file history and quickly jump to recently edited files
nnoremap <leader>b :CtrlPBuffer<CR>

" Open NerdTree (left hand sidebar file browser)
nnoremap <Leader>n :NERDTreeTabsToggle<CR>

" find current file in NERDTree
nnoremap <leader>r :NERDTreeFind<CR>

" Open Tagbar (right hand sidebar list of e.g. functions in current file)
nnoremap <leader>` :TagbarToggle<CR>

" open Ag for searching within all project files
nnoremap <leader>f :Ag<space>

" set current folder as working directory
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

" disable annoying "ex mode"
nnoremap Q <Nop>

" When editing mixed HTML/PHP files (i.e. views) sometimes
" indentation can be confused. This can be resolved usually
" by switching to HTML mode, then indenting (e.g. = OR <Cmd-a>= OR :gg=G``) 
" set the current file's syntax/indenting mode to PHP
nnoremap <leader>p :call ModePHP()<CR>
" set the current file's syntax/indenting mode to HTML
nnoremap <leader>h :call ModeHTML()<CR>
" set the current file's syntax/indenting mode to JavaScript
nnoremap <leader>j :call ModeJS()<CR>

" apply identation and source formatting to current file
nnoremap <leader>i mzgg=G`z

" look up the word under the cursor on php.net
nnoremap <F7> :call PHPHelp()<cr>
" look up the word under the cursor on Google
nnoremap <F8> :call GoogleWord()<cr>
nnoremap <F9> :call ViewInBrowser()<cr>
" switch between normal and relative line numbering
nnoremap <C-n> :call NumberToggle()<cr>

" console.log();
iab cl console.log(

" Load tags
set tags=./tags;/

" Use the Solarized Dark theme
if has('gui_running')
    set background=dark
    colorscheme solarized
    let g:solarized_termtrans=1
    set guifont=Menlo\ Regular:h13
else
    "colourscheme desert
endif

" Make Vim more useful
set nocompatible
" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed
" Enhance command-line completion
set wildmenu
" Allow cursor keys in insert mode
set esckeys
" Allow backspace in insert mode
set backspace=indent,eol,start
" Turn on auto-indenting
filetype on
filetype plugin indent on
set shiftwidth=4
set tabstop=4
set expandtab
" Optimize for fast terminal connections
set ttyfast
" Use UTF-8 without BOM
set encoding=utf-8 nobomb
" Stop creating swap files
set noswapfile
" Centralize backups and undo history
set backupdir=~/.vim/backups
if exists("&undodir")
	set undodir=~/.vim/undo
endif

" Don’t create backups when editing files in certain directories
set backupskip=/tmp/*,/private/tmp/*

" Respect modeline in files
set modeline
set modelines=4
" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure
" Enable line numbers
set number
" Enable syntax highlighting
syntax on
" Highlight current line
set cursorline
" Highlight searches
set hlsearch
" Ignore case of searches
set ignorecase
" Highlight dynamically as pattern is typed
set incsearch
" Always show status line
set laststatus=2
" Enable mouse in all modes
set mouse=a
" Disable error bells
set noerrorbells
" Don’t reset cursor to start of line when moving around.
set nostartofline
" Show the cursor position
set ruler
" Don’t show the intro message when starting Vim
set shortmess=atI
" Show the current mode
set showmode
" Show the filename in the window titlebar
set title
" Show the (partial) command as it’s being typed
set showcmd
" Use relative line numbers
"if exists("&relativenumber")
	"set relativenumber
	"au BufReadPost * set relativenumber
"endif
" Prevent double-quotes being hidden in JSON
let g:vim_json_syntax_conceal = 0
set conceallevel=0

function! NumberToggle()
  if(&relativenumber == 1)
    set nornu
  else
    set rnu
  endif
endfunc

" Start scrolling three lines before the horizontal window border
set scrolloff=3

" Strip trailing whitespace (,ss)
function! StripWhitespace()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	:%s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>
" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" Automatic commands
if has("autocmd")
	" Enable file type detection
	filetype on
	" Treat .json files as .js
	autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
    autocmd FileType yaml,yml setlocal ts=2 sts=2 sw=2 expandtab
	" Treat .md files as Markdown
	autocmd BufNewFile,BufRead *.md setlocal filetype=markdown

    " run a script
    autocmd FileType python nnoremap <buffer> <leader>c :w<CR>:exec '!python3' shellescape(@%, 1)<CR>

    " Run current file
    nnoremap <Leader>n :NERDTreeTabsToggle<CR>

endif

" Search php.net help for the function/class under the cursor
function! PHPHelp()
    let cur_word = expand("<cword>")
    let func = substitute(cur_word, "_", "-", "")
    let url = "http://php.net/search.php?pattern=" . func . "&show=quickref"
    echo url
    silent exec "!open '".url."'"
endfunction

" Search google for the function/class under the cursor
function! GoogleWord()
    let cur_word = expand("<cword>")
    let url = "http://www.google.co.uk/search?q=" . cur_word
    echo url
    silent exec "!open '".url."'"
endfunction

" Open the file being edited in a web browser
function! ViewInBrowser()
    silent exec '!open -a /Applications/Google\ Chrome.app %'
endfunction

" Toggle between vim treating a file as HTML and PHP 
" which is useful for correct indentation
function! ModeHTML()
    set filetype=html
    set syntax=html
endfunction
function! ModePHP()
    set filetype=php
    set syntax=php
endfunction
function! ModeJS()
    set filetype=javascript
    set syntax=javascript
endfunction

" Set line height
set linespace=4

command! -nargs=0 TagbarToggleStatusline call TagbarToggleStatusline()
nnoremap <leader>s :TagbarToggleStatusline<CR>
function! TagbarToggleStatusline()
   let tStatusline = '%{exists(''*tagbar#currenttag'')?
            \tagbar#currenttag(''     [%s] '',''''):''''}'
   if stridx(&statusline, tStatusline) != -1
      let &statusline = substitute(&statusline, '\V'.tStatusline, '', '')
   else
      let &statusline = substitute(&statusline, '\ze%=%-', tStatusline, '')
   endif
endfunction
