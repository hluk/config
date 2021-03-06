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
" https://www.reddit.com/r/vim/wiki/vimrctips

" OPTIONS {{{
set mouse=a
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
" automatic indentation
set autoindent
filetype plugin indent on
" cursor show next/prev parenthesis
set showmatch
" completion menu
set wildmenu
set wildmode=longest:full,full
" tab -> spaces
set expandtab
set shiftwidth=4
" keep a 5 line buffer for the cursor from top/bottom of window
set scrolloff=5
" X11 clipboard
set clipboard=unnamedplus
" use ~ with movement
set tildeop
" persistent undo history
call system('mkdir -p ~/.vim/undofiles/')
set undodir=~/.vim/undofiles/
set undofile
" 256 and more colors
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
" diff
set diffopt+=algorithm:patience
set diffopt+=indent-heuristic
" always show status line
set laststatus=2
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
autocmd BufNewFile,BufReadPost *.cpp,*.c,*.h set syntax+=.doxygen

" qml
autocmd BufRead,BufNewFile *.qml setfiletype javascript

" Jenkinsfile
autocmd BufRead,BufNewFile Jenkinsfile,*.Jenkinsfile setfiletype groovy

" git commit message
autocmd FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])|set spell|set nosmartindent|set noautoindent|set nocindent

" yaml
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd BufRead,BufNewFile ~/.config/yamllint/config setfiletype yaml
autocmd BufRead,BufNewFile */ansible/inventory/* setfiletype yaml

" ruby
autocmd FileType ruby setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType eruby setlocal ts=2 sts=2 sw=2 expandtab

" meson
autocmd BufRead,BufNewFile meson.build setlocal ts=2 sts=2 sw=2 expandtab

"" toggle comment (NERD commenter)
Plug 'scrooloose/nerdcommenter'
map <C-\> <leader>c<SPACE>j
imap <C-\> <C-o><leader>c<SPACE><DOWN>

"" taglist
"Plug 'vim-scripts/taglist.vim'
"noremap tt :TlistToggle<CR>

" Asynchronous Lint Engine
Plug 'w0rp/ale'
let g:ale_linters = {
\   'python': ['flake8',],
\}
autocmd BufEnter schema.rb ALEDisable

" snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
let g:UltiSnipsExpandTrigger="<tab>"

" fugitive (git)
Plug 'tpope/vim-fugitive'
no gitd :Gd master<CR>

" asynchronous build and test dispatcher
Plug 'tpope/vim-dispatch'

" file helpers:
" - :Mkdir, :Rename, :SudoWrite, ...
" - automatic chmod +x for new scripts
Plug 'tpope/vim-eunuch'

" Perform all your vim insert mode completions with Tab
Plug 'ervandew/supertab'
let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"
let g:SuperTabDefaultCompletionTypeDiscovery = ["&omnifunc:<c-x><c-o>","&completefunc:<c-x><c-n>"]
let g:SuperTabClosePreviewOnPopupClose = 1

" Python
" PEP 8
Plug 'nvie/vim-flake8'
" :Black
Plug 'python/black'

" Rust syntax
Plug 'rust-lang/rust.vim'

" Ruby on Rails
Plug 'tpope/vim-rails'

" Jinja2
Plug 'Glench/Vim-Jinja2-Syntax'

" meson
Plug 'igankevich/mesonic'

" fzf
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
let g:fzf_layout = { 'right': '~70%' }
let g:fzf_history_dir = '~/.local/share/fzf-history'
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
map <c-k> :Files<CR>
map <c-g> :Rg<CR>
" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" grammar checker
Plug 'rhysd/vim-grammarous'

" Color schemes
Plug 'sjl/badwolf'
Plug 'morhetz/gruvbox'

" reopen files at your last edit position
Plug 'farmergreg/vim-lastplace'

call plug#end()
" }}}

" KEYS {{{
" faster commands
nnoremap ; :

" typos
command! Q :q
command! Qa :qa
command! W :w
command! Wq :wq
command! WQ :wq

" edit/source configuration
noremap <C-e>e :split ~/.vimrc <CR>
noremap <C-e>r :source ~/.vimrc <CR>

" clear highlighted search term on space
noremap <silent> <Space> :nohlsearch<CR>

" reselect visual block after indent
vnoremap < <gv
vnoremap > >gv

inoremap jj <Esc>
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
set spell
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
