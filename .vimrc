" USAGE:
" :h index
" :options
" :read -- open file read only
" :setl ar -- automatically reload file if changed
" q/ -- search history
" q: -- command history
" gf -- open file which filename is under cursor
" gi -- go to last insert mode place
" g; -- go to last change
" g, -- go to next change
" ~  -- change case of letter
" gq -- reformat
"
" :g/PATTERN/norm ... -- do something with each matched line (e.g. delete with dd)

" http://vimbits.com/bits?sort=top

" OPTIONS {{{
set nocompatible
set mouse=a
set ttyfast
set lazyredraw
" highlight matched
set hlsearch
" command history size
set history=512
" case insensitive search
set ignorecase
set smartcase
" search while typing
set incsearch
" show numbers
set number
" C indent
set cin
" cursor show next/prev parenthesis
set showmatch
" show pressed keys in lower right corner
set showcmd
" completion menu
set wildmenu
set wildmode=longest:full,full
" vim scans first and last few lines for file settings
set modeline
" always show status line
set laststatus=2
" tab -> spaces
set expandtab
set tabstop=8
set shiftwidth=4
" keep a 5 line buffer for the cursor from top/bottom of window
set scrolloff=5
" syntax
syntax on
" X11 clipboard
set clipboard=unnamed
" use ~ with movement
set tildeop
" persistent undo history
set undodir=~/.vim/undofiles/
set undofile
" 256 and more colors
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
" }}}

" PLUGINS {{{
" https://github.com/junegunn/vim-plug
"   curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" :PlugInstall to install new plugins
" :PlugUpdate to update plugins
" :PlugUpgrade to upgrade vim-plug
call plug#begin('~/.vim/plugged')

" doxygen
au BufNewFile,BufReadPost *.cpp,*.c,*.h set syntax+=.doxygen

" qml
au BufRead,BufNewFile *.qml setfiletype javascript

" git commit message
au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])|set spell|set nosmartindent|set noautoindent|set nocindent

"" toggle comment (NERD commenter)
Plug 'scrooloose/nerdcommenter'
map <C-\> <leader>c<SPACE>j
imap <C-\> <C-o><leader>c<SPACE><DOWN>

"" taglist
"Plug 'vim-scripts/taglist.vim'
"noremap tt :TlistToggle<CR>

" Syntastic
"Plug 'scrooloose/syntastic'
"nnoremap <F6> :Errors<CR>
"let g:syntastic_mode_map = {
"            \ 'mode': 'active',
"            \ 'active_filetypes': [],
"            \ 'passive_filetypes': ['c', 'cpp']
"            \ }

" Asynchronous Lint Engine
Plug 'w0rp/ale'
let g:ale_linters = {
\   'python': ['flake8',],
\}

" snippets
"Plug 'msanders/snipmate.vim'
" view/edit snippets; call ReloadAllSnippets() after editing
"noremap <C-n>n :execute 'sv ~/.vim/bundle/snipmate.vim/snippets/'.&ft.'.snippets'<CR>
"noremap <C-n>m :execute 'vs ~/.vim/snippets/'.&ft.'.snippets'<CR>
"noremap <C-n>r :call ReloadAllSnippets()<CR>
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
let g:UltiSnipsExpandTrigger="<tab>"

" fugitive (git)
Plug 'tpope/vim-fugitive'
no gitd :Gd master<CR>

filetype plugin indent on

" asynchronous build and test dispatcher
Plug 'tpope/vim-dispatch'

" Perform all your vim insert mode completions with Tab
Plug 'ervandew/supertab'
let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"
let g:SuperTabDefaultCompletionTypeDiscovery = ["&omnifunc:<c-x><c-o>","&completefunc:<c-x><c-n>"]
let g:SuperTabClosePreviewOnPopupClose = 1

" Python
" PEP 8
Plug 'nvie/vim-flake8'

" Rust syntax
Plug 'rust-lang/rust.vim'

" fzf
"Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
let g:fzf_layout = { 'right': '~100%' }
imap <c-x><c-f> <plug>(fzf-complete-path)
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)
" Files command with preview window
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
map <c-t> :Files<CR>
map <c-g> :Rg<CR>
" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" Color schemes
Plug 'sjl/badwolf'
Plug 'morhetz/gruvbox'

call plug#end()
" }}}

" KEYS {{{
" faster commands
"nnoremap ; :

" typos
command! Q :q
command! W :w
command! Wq :wq
command! WQ :wq

" F5 to make
noremap <F5> :w<CR>:Make<CR><CR>
inoremap <F5> <C-o>:w<CR><C-O>:Make<CR><CR>
"noremap <F1> :set makeprg=cat\ ../build/make.log\|make<CR>
"inoremap <F5> <C-o>:set makeprg=cat\ ../build/make.log\|make<CR>
map <F6> run

" run/execute current file
noremap <C-.> :w<CR>:!./%<CR>
inoremap <C-.> <C-o>:w<CR><C-o>:!./%<CR>

" edit/source configuration
noremap <C-e>e :split ~/.vimrc <CR>
noremap <C-e>r :source ~/.vimrc <CR>

" clear highlighted search term on space
noremap <silent> <Space> :nohls<CR>

" reselect visual block after indent
vnoremap < <gv
vnoremap > >gv

inoremap jj <Esc>

" tag
map tg :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
map tj  :exec("pta ".expand("<cword>"))<CR>
map TT :!~/dev/bin/tags.sh<CR>
" }}}

" COMPLETION {{{
" don't complete some filenames
set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.o,*.obj,*.exe,*.dll            " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.pyc                            " python binaries
set wildignore+=*.luac                           " Lua byte code
" don't complete multimedia binary files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg
set wildignore+=*.flv,.*mp4,*.mp3,*.wav,*.wmv,*.avi,*.mkv,*.mov

"set completeopt=longest,menuone,preview
"set completeopt=longest,menuone,menu
"}}}

" DICTIONARY (C-x C-k) {{{
"set dictionary+=/usr/share/dict/words
"set spelllang=cs
map <F7> :set spell!<CR>
"}}}

" FOLDS {{{
set foldmethod=marker
set foldnestmax=2
"}}}

" TABS {{{
noremap tn :tabnew<space>
noremap td :tabclose<CR>
noremap <C-L> :tabnext<CR>
noremap <C-H> :tabprev<CR>
inoremap <C-L> <C-o>:tabnext<CR>
inoremap <C-H> <C-o>:tabprev<CR>
"}}}

" HEX {{{
command! Xxd :%!xxd
command! Xxdr :%!xxd -r
"}}}

" HIGHLIGHT {{{
" highlight extra spaces
hi def link ExtraWhitespace Error
au BufNewFile,BufReadPost,InsertLeave,InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/

" show tabs and trailing spaces
set list
set listchars=tab:▸\ ,trail:⋅

" show syntax highlighting groups for word under cursor
nmap g<C-G> :echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')<CR>
"}}}

" APPEARANCE {{{
set bg=dark
"colorscheme badwolf
"colorscheme zenburn
"colorscheme mustang
"colorscheme desert
"colorscheme wombat
"colorscheme onedark
"colorscheme molokai
colorscheme gruvbox
"}}}

" MOVE LINE/BLOCK {{{
nnoremap <C-S-J> :m+<CR>==
nnoremap <C-S-K> :m-2<CR>==
inoremap <C-S-J> <Esc>:m+<CR>==gi
inoremap <C-S-K> <Esc>:m-2<CR>==gi
vnoremap <C-S-J> :m'>+<CR>gv=gv
vnoremap <C-S-K> :m-2<CR>gv=gv
"}}}

" HARD MODE {{{
nnoremap <Left> <NOP>
nnoremap <Right> <NOP>
nnoremap <Up> <NOP>
nnoremap <Down> <NOP>
nnoremap <PageUp> <NOP>
nnoremap <PageDown> <NOP>

inoremap <Left> <NOP>
inoremap <Right> <NOP>
inoremap <Up> <NOP>
inoremap <Down> <NOP>
inoremap <PageUp> <NOP>
inoremap <PageDown> <NOP>

vnoremap <Left> <NOP>
vnoremap <Right> <NOP>
vnoremap <Up> <NOP>
vnoremap <Down> <NOP>
vnoremap <PageUp> <NOP>
vnoremap <PageDown> <NOP>

"set backspace=0
"}}}

