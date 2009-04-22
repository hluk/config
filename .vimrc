set nocompatible
set mouse=a
set fileencodings=utf-8,iso8859-2,cp1250
set fileformats=unix,dos
set binary
" command history size
set history=512
" case insensitive search
set ignorecase
" from-end-to-beginning search
" search while typing
set incsearch
" show numbers
set number
" highlight cursor line
set cursorline
" C indent
set cin
" cursor show next/prev parenthesis
set showmatch
" show pressed keys in lower right corner
set showcmd
"set backspace=indent,eol,start
set nojoinspaces
" register "unnamed" == clipboard
set clipboard=unnamed
" completion char in :
set wildchar=<Tab>
" completion menu
set wildmenu
set wildmode=longest:full,full
" vim scans first and last few lines for file settings
set modeline

filetype plugin on
filetype indent on

" 256 colors
set t_Co=256
set t_AB=[48;5;%dm
set t_AF=[38;5;%dm

" font in gui
if has("gui_running")
	gui
	"set guifont=Bitstream\ Vera\ Sans\ Mono\ 12
	"set guifont=Liberation\ Mono\ 12
	"set guifont=Monospace\ 12
	"set guifont=DejaVu\ Sans\ Mono\ 12
	set guifont=Consolas\ 13
	"set guifont=Inconsolata\ 14
	colorscheme rainbow_breeze
else
	"colorscheme redblack
	"colorscheme 256-jungle
	"colorscheme molokai
	"colorscheme wombat256
	"colorscheme kellys
	
        "colorscheme calmar256-light
	"colorscheme soso
	colorscheme khaki
endif

" colors

"" Make Vim completion popup menu work just like in an IDE (Matt Zyzik)
set completeopt=longest,menuone
inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"
inoremap <expr> <c-n> pumvisible() ? "\<lt>c-n>" : "\<lt>c-n>\<lt>c-r>=pumvisible() ? \"\\<lt>down>\" : \"\"\<lt>cr>" 
inoremap <expr> <m-;> pumvisible() ? "\<lt>c-n>" : "\<lt>c-x>\<lt>c-o>\<lt>c-n>\<lt>c-p>\<lt>c-r>=pumvisible() ? \"\\<lt>down>\" : \"\"\<lt>cr>"

"" Dictionary Word Completion Using Ctrl-x Ctrl-k
set dictionary+=/usr/share/dict/words
"" spell checking
"set spelllang=cs
map <silent> <F7> :call Cream_spellcheck()<CR>
imap <silent> <F7> <C-o>:call Cream_spellcheck()<CR>
vmap <silent> <F7> :<C-u>call Cream_spellcheck("v")<CR>
imap <silent> <M-F7> <C-o>:call Cream_spell_altword()<CR>
vmap <silent> <M-F7> :<C-u>call Cream_spell_altword("v")<CR>
" spell keys
map <F6> :w<CR>:!LANG=cs_CZ.iso-8859-2 aspell -t -x --lang=cs -c %<CR>:<CR>:e<CR><CR>k
imap <F6> <ESC>:w<CR>:!LANG=cs_CZ.iso-8859-2 aspell -t -x --lang=cs -c %<CR>:e<CR><CR>ki

"" FOLDS
set foldmethod=marker
"set foldmethod=syntax
nmap <F9> za
nmap <C-F9> zR
nmap <C-S-F9> zM

"" TABS
map tn :tabnew<CR>
map td :tabclose<CR>

"" toggle comment
map <C-C> ,c<SPACE>j
imap <C-C> <C-o>,c<SPACE><DOWN>

"" taglist
map tt :TlistToggle<CR>

"" omnicpp C++ code completion
" RUN: exuberant-ctags -R --c++-kinds=+p --fields=+iaS --extra=+q -f ~/.vim/systags /usr/include/
autocmd FileType c    set tags+=~/.vim/tags_c
autocmd FileType cpp  set tags+=~/.vim/tags_cpp
autocmd FileType ruby set tags+=~/.vim/tags_ruby
autocmd FileType java set tags+=~/.vim/tags_java
"set tags+=~/.vim/ctags
"noremap <F12> :!exuberant-ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
noremap <F12> :!exuberant-ctags -R .<CR>
autocmd FileType ruby noremap <F11> :!exuberant-ctags --totals --lang-map=Ruby:+.rb -f ~/.vim/tags_ruby -R /usr/lib/ruby/gems /usr/lib/ruby/site_ruby<CR>

autocmd FileType haskell set expandtab

" pysmell autocompletion for python
" first generate tags with 'pysmell .' in project path
"autocmd FileType python setlocal omnifunc=pysmell#Complete

" KEYS
" save
map <F2> :w<CR>
imap <F2> <C-o>:w<CR>
map <C-S> :w<CR>
imap <C-S> <C-o>:w<CR>
" quit
map <C-q> :qa<CR>
imap <C-q> <C-o>:qa<CR>
" make
map <F5> :make<CR>
imap <F5> <C-o>:make<CR>

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

