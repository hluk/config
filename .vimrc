set nocp
set fileencodings=utf-8,iso8859-2,cp1250
set fileformats=unix,dos
set binary
set ignorecase
set incsearch

filetype plugin on
filetype indent on

" colorscheme GUIxCONSOLE
if has("gui_running")
	colorscheme grayorange
	"set guifont=Bitstream\ Vera\ Sans\ Mono\ 9
	"set guifont=Liberation\ Mono\ 9
	"set guifont=Monospace\ 9
	"set guifont=Monaco\ 9
	set guifont=DejaVu\ Sans\ Mono\ 9
else
	colorscheme grayorange
endif

set wildchar=<Tab>
set wildmenu
set wildmode=longest:full,full

" Make Vim completion popup menu work just like in an IDE (Matt Zyzik)
set completeopt=longest,menuone
inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"
inoremap <expr> <c-n> pumvisible() ? "\<lt>c-n>" : "\<lt>c-n>\<lt>c-r>=pumvisible() ? \"\\<lt>down>\" : \"\"\<lt>cr>" 
inoremap <expr> <m-;> pumvisible() ? "\<lt>c-n>" : "\<lt>c-x>\<lt>c-o>\<lt>c-n>\<lt>c-p>\<lt>c-r>=pumvisible() ? \"\\<lt>down>\" : \"\"\<lt>cr>"

" Toggle spell checking
set spelllang=cs
map <silent> <F7> :call Cream_spellcheck()<CR>
imap <silent> <F7> <C-o>:call Cream_spellcheck()<CR>
vmap <silent> <F7> :<C-u>call Cream_spellcheck("v")<CR>
imap <silent> <M-F7> <C-o>:call Cream_spell_altword()<CR>
vmap <silent> <M-F7> :<C-u>call Cream_spell_altword("v")<CR>

map <F6> :w<CR>:!LANG=cs_CZ.iso-8859-2 aspell -t -x --lang=cs -c %<CR>:<CR>:e<CR><CR>k
imap <F6> <ESC>:w<CR>:!LANG=cs_CZ.iso-8859-2 aspell -t -x --lang=cs -c %<CR>:e<CR><CR>ki

set nocompatible
set mouse=a

" FOLDS
set foldmethod=marker
"set foldmethod=syntax
nmap <F9> za
nmap <C-F9> zR
nmap <C-S-F9> zM

" tabs
map tn :tabnew<CR>
map td :tabclose<CR>

" toggle comment
map <C-C> ,c<SPACE>j
imap <C-C> <C-o>,c<SPACE><DOWN>

" taglist
map tt :TlistToggle<CR>

" omnicpp C++ code completion
" RUN: exuberant-ctags -R --c++-kinds=+p --fields=+iaS --extra=+q -f ~/.vim/systags /usr/include/
autocmd FileType c    set tags+=~/.vim/tags_c
autocmd FileType cpp  set tags+=~/.vim/tags_cpp
autocmd FileType ruby set tags+=~/.vim/tags_ruby
autocmd FileType java set tags+=~/.vim/tags_java
"set tags+=~/.vim/ctags
"noremap <F12> :!exuberant-ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
noremap <F12> :!exuberant-ctags -R .<CR>
autocmd FileType ruby noremap <F11> :!exuberant-ctags --totals --lang-map=Ruby:+.rb -f ~/.vim/tags_ruby -R /usr/lib/ruby/gems /usr/lib/ruby/site_ruby<CR>

" pysmell autocompletion for python
" first generate tags with 'pysmell .' in project path
autocmd FileType python setlocal omnifunc=pysmell#Complete

" F2 save
map <F2> :w<CR>
imap <F2> <C-o>:w<CR>

" F5 make
map <F5> :make<CR>
imap <F5> <C-o>:make<CR>

set nu
set cursorline

" C indent
set cin

" cursor show next/prev parenthesis
set showmatch

set showcmd

" set backspace=indent,eol,start

set nojoinspaces

" register "unnamed" == clipboard
set clipboard=unnamed

" omni-completion shortcut alias
imap <C-Tab> <C-X><C-O>

" expedite ~/.vimrc edit & reload
map <C-e> :split ~/.vimrc <CR>
map <C-u> :source ~/.vimrc <CR>

" HEX
map <silent> <C-h> :%!xxd<CR>
imap <silent> <C-h> <C-o>:%!xxd<CR>
vmap <silent> <C-h> :<C-u>!xxd<CR>
map <silent> <C-M-h> :%!xxd -r<CR>
imap <silent> <C-M-h> <C-o>:%!xxd -r<CR>
vmap <silent> <C-M-h> :<C-u>!xxd -r<CR>

let NERDShutUp=1

set history=512

function! TextEnableCodeSnip(filetype,start,end) abort
  let ft=toupper(a:filetype)
  let group='textGroup'.ft
  if exists('b:current_syntax')
    let s:current_syntax=b:current_syntax
    " Remove current syntax definition, as some syntax files (e.g. cpp.vim)
    " do nothing if b:current_syntax is defined.
    unlet b:current_syntax
  endif
  execute 'syntax include @'.group.' syntax/'.a:filetype.'.vim'
  try
    execute 'syntax include @'.group.' after/syntax/'.a:filetype.'.vim'
  catch
  endtry
  if exists('s:current_syntax')
    let b:current_syntax=s:current_syntax
  else
    unlet b:current_syntax
  endif
  execute 'syntax region textSnip'.ft.'
  \ matchgroup=textSnip
  \ start="'.a:start.'" end="'.a:end.'"
  \ contains=@'.group
  hi link textSnip SpecialComment
endfunction

call TextEnableCodeSnip( 'lua', '%{{{lua', '%lua}}}' )

