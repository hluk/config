" USAGE:
" :read -- open file read only
" :setl ar -- automatically reload file if changed
" q/ -- search history
" q: -- command history
" gf -- open file which filename is under cursor

" OPTIONS {{{
set nocompatible
set mouse=a
set ttyfast
set lazyredraw
" save power
set nofsync
set nobackup
" file format/encoding
"set fileencodings=utf-8,iso8859-2,cp852,cp1250
"set fileformats=unix,dos
"set binary
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
" highlight cursor line (slow)
"set cursorline
" C indent
set cin
" cursor show next/prev parenthesis
set showmatch
" show pressed keys in lower right corner
set showcmd
" backspace deletes
"set backspace=indent,eol,start
" completion menu
set wildmenu
set wildmode=longest:full,full
" vim scans first and last few lines for file settings
set modeline
" always show status line
set laststatus=2
" tab -> spaces
set expandtab
set tabstop=4
set shiftwidth=4
" keep a 5 line buffer for the cursor from top/bottom of window
set scrolloff=5
" syntax
syntax on
" X11 clipboard
set clipboard=unnamed
" }}}

" BASE PLUGINS {{{
" plugin loader (~/.vim/bundle/*)
" must be called before "filetype indent on"
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'
" :BundleInstall to install new plugins
" :BundleInstall! to update plugins

" coffee-script filetype plugin
Bundle 'git://github.com/kchmck/vim-coffee-script.git'
" folds based on indentation
au BufNewFile,BufReadPost *.coffee setl foldmethod=indent

" vala
au BufRead *.vala,*.vapi set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
au BufRead,BufNewFile *.vala,*.vapi setfiletype vala

" qml
au BufRead,BufNewFile *.qml setfiletype javascript

filetype plugin on
filetype indent on
" }}}

" KEYS {{{
" faster commands
nnoremap ; :

" typos
command! Q :q
command! W :w
command! Wq :wq
command! WQ :wq

" F5 to make
map <F5> :make!<CR><CR>
imap <F5> <C-o>:make!<CR><CR>

" F2 to save
map <F2> :w<CR>
imap <F2> <C-o>:w<CR>

" run/execute current file
map <C-.> :w<CR>:!./%<CR>
imap <C-.> <C-o>:w<CR><C-o>:!./%<CR>

" edit/reload configuration
map <C-e> :split ~/.vimrc <CR>
map <C-u> :source ~/.vimrc <CR>

" clear highlighted search term on space
noremap <silent> <Space> :silent noh<Bar>echo<CR>
" }}}

" PLUGINS {{{
"" toggle comment (NERD commenter)
Bundle 'git://github.com/scrooloose/nerdcommenter.git'
map <C-C> <leader>c<SPACE>j
imap <C-C> <C-o><leader>c<SPACE><DOWN>

"" taglist
Bundle 'git://github.com/vim-scripts/taglist.vim.git'
map tt :TlistToggle<CR>

"" NERDTree
"Bundle 'git://github.com/scrooloose/nerdtree.git'
"map ff :NERDTreeToggle<CR>
"let NERDShutUp=1

" Syntastic
Bundle 'git://github.com/scrooloose/syntastic.git'
nnoremap <F6> :Errors<CR>

" ctrlp - file/buffer finder
" C-p - open list
" C-z and C-o - mark files and open them
Bundle 'git://github.com/kien/ctrlp.vim.git'
" browse nearest parent directory with .git, .hg, root.dir etc.
"let g:ctrlp_working_path_mode = 2
let g:ctrlp_working_path_mode = 1
let g:ctrlp_dotfiles = -1
let g:ctrlp_max_files = 5000
let g:ctrlp_max_depth = 6
let g:ctrlp_custom_ignore = '\.\(jpg\|png\|gif\|jpe\|jpeg\|flv\|mp4\|mp3\|wmv\|avi\|mkv\|mov\)$'

" Command-t
"Bundle 'git://github.com/wincent/Command-T.git'

"Bundle 'L9'
"Bundle 'FuzzyFinder'
"noremap <leader>t :FufFile<CR>

" :Ack [options] {pattern} [{directory}]
" o    to open (same as enter)
" go   to preview file (open but maintain focus on ack.vim results)
" t    to open in new tab
" T    to open in new tab silently
" v    to open in vertical split
" gv   to open in vertical split silently
" q    to close the quickfix window
Bundle 'git://github.com/mileszs/ack.vim.git'

" snippets
Bundle 'git://github.com/msanders/snipmate.vim.git'
" view/edit snippets; call ReloadAllSnippets() after editing
noremap <C-n>n :execute 'sv ~/.vim/bundle/snipmate.vim/snippets/'.&ft.'.snippets'<CR>
noremap <C-n>m :execute 'vs ~/.vim/snippets/'.&ft.'.snippets'<CR>
noremap <C-n>r :call ReloadAllSnippets()<CR>

" powerline - statusline
Bundle "git://github.com/Lokaltog/vim-powerline.git"
let g:Powerline_symbols='fancy'
"}}}

" COMPLETION {{{
" don't complete some filenames
set wildignore=*.o,*.pyc

"set completeopt=longest,menuone,preview
set completeopt=longest,menuone,menu

" Clang complete
Bundle 'https://github.com/Rip-Rip/clang_complete.git'
let g:clang_use_library = 1
let g:clang_auto_select = 1
let g:clang_snippets = 1
let g:clang_library_path = '/usr/lib/llvm/'
let g:clang_complete_copen = 1
let g:clang_complete_auto = 0
"}}}

" MOVE LINE/BLOCK {{{
nnoremap Ob :m+<CR>==
nnoremap Oa :m-2<CR>==
inoremap Ob <Esc>:m+<CR>==gi
inoremap Oa <Esc>:m-2<CR>==gi
vnoremap Ob :m'>+<CR>gv=gv
vnoremap Oa :m-2<CR>gv=gv
"}}}

" DICTIONARY (C-x C-k) {{{
"set dictionary+=/usr/share/dict/words
"set spelllang=cs
map <F7> :set spell<CR>
map <S-F7> :set nospell<CR>
"}}}

" FOLDS {{{
set foldmethod=marker
"set foldmethod=syntax
set foldnestmax=2
"}}}

" TABS {{{
map tn :tabnew<space>
map td :tabclose<CR>
map <C-T> :tabnext<CR>
map <S-C-T> :tabprev<CR>
imap <C-T> <C-o>:tabnext<CR>
imap <S-C-T> <C-o>:tabprev<CR>
"}}}

" WINDOWS {{{
map <TAB> <C-W><C-W>
map <S-TAB> <C-W><S-W>
"}}}

" HEX {{{
command! Xxd :%!xxd
command! Xxdr :%!xxd -r
"}}}

" HIGHLIGHT {{{
" highlight extra spaces
"highlight ExtraWhitespace ctermbg=red guibg=red
hi def link ExtraWhitespace Error
au BufNewFile,BufReadPost,InsertLeave,InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/

" Show syntax highlighting groups for word under cursor
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
nmap <C-H> :call <SID>SynStack()<CR>
"}}}

" Change the color scheme {{{
"   :SetSchemes                  (all $VIMRUNTIME/colors/*.vim)
"   :SetSchemes blue slate ron   (these schemes)

let s:scheme_index = 0
let s:current_scheme = []
let s:schemes = []

" Set list of color scheme names that we will use, except
" argument 'now' actually changes the current color scheme.
function! s:SetSchemes(args)
    if len(a:args) == 0
        let paths = split(globpath(&runtimepath, 'colors/*.vim'), "\n")
        let s:schemes = map(copy(paths), 'fnamemodify(v:val, ":t:r").":light"')
        let s:schemes += map(paths, 'fnamemodify(v:val, ":t:r").":dark"')
        call SetScheme(0)
    else
        let s:schemes = split(a:args)
        call SetScheme(0)
    endif
endfunction

command! -nargs=* SetSchemes call <SID>SetSchemes('<args>')

function! SetScheme(i)
    let s:scheme_index = a:i % len(s:schemes)
    let s:current_scheme = split(s:schemes[s:scheme_index], ':')
    try
        execute 'colorscheme '.s:current_scheme[0]
        if len(s:current_scheme) > 1
            execute 'set background='.s:current_scheme[1]
        endif
    catch /E185:/
        echo 'Selected colorscheme not found ('.s:current_scheme[0].')!'
    endtry
    redraw
endfunction

function! NextScheme(how)
    call SetScheme(s:scheme_index + a:how)
    echo 'colorscheme '.join(s:current_scheme)
endfunction

nnoremap <F9> :call NextScheme(1)<CR>
nnoremap <F8> :call NextScheme(-1)<CR>
inoremap <F9> <C-o>:call NextScheme(1)<CR>
inoremap <F8> <C-o>:call NextScheme(-1)<CR>
"}}}

" GUI/console appearance {{{
" solarized color theme
Bundle 'git://github.com/altercation/vim-colors-solarized.git'
let g:solarized_termtrans=0
let g:solarized_termcolors=256
let g:solarized_contrast="high"
let g:solarized_visibility="high"

if has("gui_running")
    gui
    let &guicursor = &guicursor . ",a:blinkon0"
    "set guifont=Bitstream\ Vera\ Sans\ Mono\ 11.5
    set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 11.5

    " zoom
    function! Zoom(how)
      let &guifont = substitute(&guifont, '[0-9.]\+$', '\=str2float(submatch(0))+' . string(a:how), '')
    endfunction
    map <C-F1> :execute Zoom(0.5)<CR>
    map <C-F2> :execute Zoom(-0.5)<CR>

    SetSchemes soso solarized wombat molokai summerfruit256
else
    SetSchemes kellys denim morning solarized:light soso zenburn mustang wombat256
endif
call SetScheme(0)
"}}}

