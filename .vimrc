" USAGE:
" :read -- open file read only
" :setl ar -- automatically reload file if changed
" q/ -- search history
" q: -- command history
" gf -- open file which filename is under cursor
set nocompatible
set mouse=a
set ttyfast
set lazyredraw
" save power
set nofsync
set nobackup
" file format/encoding
set fileencodings=utf-8,iso8859-2,cp852,cp1250
set fileformats=unix,dos
set binary
" highlight matched
set hlsearch
" command history size
set history=512
" case insensitive search
set ignorecase
set smartcase
" from-end-to-beginning search
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
"set backspace=indent,eol,start
set nojoinspaces
" completion char in :
set wildchar=<Tab>
" completion menu
set wildmenu
set wildmode=longest:full,full
" vim scans first and last few lines for file settings
set modeline
" tab -> spaces
set expandtab
set tabstop=4
set shiftwidth=4
" keep a 5 line buffer for the cursor from top/bottom of window
set scrolloff=5
"syntax
syntax on
" X11 clipboard
"   command 'vim -X' provides faster startup and
"   serverlist() enables usage of X11 clipboard
call serverlist()
set clipboard=unnamed

" plugin loader (~/.vim/bundle/*)
" must be called before "filetype indent on"
filetype off
"call pathogen#runtime_append_all_bundles()
"call pathogen#helptags()
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'
" run :BundleInstall

Bundle 'git://github.com/kchmck/vim-coffee-script.git'

filetype plugin on
filetype indent on

" faster commands
nnoremap ; :

" typos
command! Q :q
command! W :w
command! Wq :wq
command! WQ :wq

" make
"map <F5> :make<CR>
"imap <F5> <C-o>:make<CR>
map <F5> :make!<CR><CR>
imap <F5> <C-o>:make!<CR><CR>

map <F2> :w<CR>
imap <F2> <C-o>:w<CR>

" screen
"nmap \| :call system("screen")<CR>
nmap \| :!screen<CR><CR>

" run/execute current file
map <C-CR> :w<CR>:!./%<CR>
imap <C-CR> <C-o>:w<CR><C-o>:!./%<CR>

" edit/reload configuration
map <C-e> :split ~/.vimrc <CR>
map <C-u> :source ~/.vimrc <CR>

" clear highlighted search term on space
noremap <silent> <Space> :silent noh<Bar>echo<CR>

" PLUGINS {{{
"" toggle comment (NERD commenter)
map <C-C> <leader>c<SPACE>j
imap <C-C> <C-o><leader>c<SPACE><DOWN>

"" taglist
map TT :TlistToggle<CR>

"" NERDTree
map tt :NERDTreeToggle<CR>
let NERDShutUp=1

" Gundo -- undo tree
"Bundle 'http://github.com/sjl/gundo.vim.git'
"nnoremap U :GundoToggle<CR>

" Syntastic
Bundle 'git://github.com/scrooloose/syntastic.git'
nnoremap <F6> :SyntasticEnable<CR>:Errors<CR>

" ctrlp - file/buffer finder
" C-p - open list
" C-z and C-o - mark files and open them
Bundle 'git://github.com/kien/ctrlp.vim.git'
"}}}

" MOVE LINE/BLOCK {{{
"nnoremap Ob :m+<CR>==
"nnoremap Oa :m-2<CR>==
"inoremap Ob <Esc>:m+<CR>==gi
"inoremap Oa <Esc>:m-2<CR>==gi
"vnoremap Ob :m'>+<CR>gv=gv
"vnoremap Oa :m-2<CR>gv=gv
nnoremap [1;5B :m+<CR>
nnoremap [1;5A :m-2<CR>
inoremap [1;5B <Esc>:m+<CR>gi
inoremap [1;5A <Esc>:m-2<CR>gi
vnoremap [1;5B :m'>+<CR>gv
vnoremap [1;5A :m-2<CR>gv
"}}}

" COMPLETION {{{
let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
"let g:SuperTabDefaultCompletionType = "<C-X><C-U>"
"let g:SuperTabDefaultCompletionType = "context"
let g:acp_completeoptPreview = 1

" don't complete on files you never need to open
set wildignore=*.o,*.pyc

"inoremap <C-Space> <C-X><C-U>
inoremap <C-@> <C-X><C-U>

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

" DICTIONARY (C-x C-k) {{{
set dictionary+=/usr/share/dict/words
"" spell checking
"set spelllang=cs
map <F7> :set spell<CR>
map <S-F7> :set nospell<CR>
" spell keys
"map <F6> :w<CR>:!LANG=cs_CZ.iso-8859-2 aspell -t -x --lang=cs -c %<CR>:<CR>:e<CR><CR>k
"imap <F6> <ESC>:w<CR>:!LANG=cs_CZ.iso-8859-2 aspell -t -x --lang=cs -c %<CR>:e<CR><CR>ki
"}}}

" FOLDS {{{
set foldmethod=marker
"set foldmethod=syntax
"}}}

" TABS {{{
map tn :tabnew<space>
map td :tabclose<CR>
map [5^ :tabprev<CR>
map [6^ :tabnext<CR>
map [5;5~ :tabprev<CR>
map [6;5~ :tabnext<CR>
map [1;5D :tabprev<CR>
map [1;5C :tabnext<CR>
imap [5^ <C-o>:tabprev<CR>
imap [6^ <C-o>:tabnext<CR>
imap [1;5D <C-o>:tabprev<CR>
imap [1;5C <C-o>:tabnext<CR>
map <C-Tab> :tabnext<CR>
map <S-C-Tab> :tabprev<CR>
imap <C-Tab> <C-o>:tabnext<CR>
imap <S-C-Tab> <C-o>:tabprev<CR>
"}}}

" WINDOWS {{{
map <TAB> <C-W><C-W>
map <S-TAB> <C-W><S-W>
"let g:miniBufExplMapCTabSwitchBufs = 1
"imap <C-Tab> <C-o><C-Tab>
"imap <S-C-Tab> <C-o><S-C-Tab>
"}}}

" HEX {{{
command! Xxd :%!xxd
command! Xxdr :%!xxd -r
"}}}

" Show syntax highlighting groups for word under cursor {{{
nmap <C-S-P> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
"}}}

" Change the color scheme {{{
"   :SetSchemes all              (all $VIMRUNTIME/colors/*.vim)
"   :SetSchemes blue slate ron   (these schemes)
"   :SetSchemes                  (display current scheme names)

let s:scheme_index = 0
let s:current_scheme = []
let s:schemes = []

" Set list of color scheme names that we will use, except
" argument 'now' actually changes the current color scheme.
function! s:SetSchemes(args)
    if len(a:args) == 0
        echo 'Current color scheme names:'
        let i = 0
        while i < len(s:schemes)
            echo '  '.join(map(s:schemes[i : i+4], 'printf("%-14s", v:val)'))
            let i += 5
        endwhile
    elseif a:args == 'all'
        let paths = split(globpath(&runtimepath, 'colors/*.vim'), "\n")
        let s:schemes = map(copy(paths), 'fnamemodify(v:val, ":t:r").":light"')
        let s:schemes += map(paths, 'fnamemodify(v:val, ":t:r").":dark"')
        echo 'List of colors set from all installed color schemes'
        call SetScheme(0)
    else
        let s:schemes = split(a:args)
        echo 'List of colors set from argument (space-separated names)'
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

" Set color scheme according to current time of day.
function! HourScheme()
  let hr = str2nr(strftime('%H'))
  if hr <= 7
    let i = 0
  elseif hr <= 8
    let i = 1
  elseif hr <= 10
    let i = 1
  elseif hr <= 16
    let i = 2
  elseif hr <= 18
    let i = 3
  else
    let i = 4
  endif
  call SetScheme(i)
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
    set guifont=Bitstream\ Vera\ Sans\ Mono\ 11.5

    " zoom {{{
    function! Zoom(how)
      let &guifont = substitute(&guifont, '[0-9.]\+$', '\=str2float(submatch(0))+' . string(a:how), '')
    endfunction

    map <C-F1> :execute Zoom(0.5)<CR>
    map <C-F2> :execute Zoom(-0.5)<CR>
    "}}}

    let s:schemes = ['solarized', 'soso', 'wombat', 'molokai', 'summerfruit256']
    call HourScheme()
else
    let s:schemes = ['solarized:dark', 'solarized:light', 'soso', 'zenburn', 'mustang', 'wombat256', 'xoria256']
    call HourScheme()
endif
"}}}

" visually differentiate normal and insert modes"{{{
"let s:n_laststatus=&laststatus
set laststatus=2
function! ModeEntered(mode)
    if a:mode == 'i'
        hi StatusLine term=reverse ctermbg=white ctermfg=red
        "hi LineNr ctermfg=white ctermbg=red
        "hi StatusLine term=reverse ctermfg=black ctermbg=green
        "hi LineNr ctermfg=black ctermbg=green

        "set cursorline
        "set cursorcolumn
    else
        execute 'colorscheme '.s:schemes

        "set nocursorline
        "set nocursorcolumn
    endif
endfunction

"au InsertEnter * set cursorline
"au InsertLeave * set nocursorline
"au InsertEnter * call ModeEntered('i')
"au InsertLeave * call ModeEntered('n')
"}}}

" LINE TOO LONG {{{
"if exists('+colorcolumn')
    "set colorcolumn=81
    "highlight link OverLength ColorColumn
    "exec 'match OverLength /\%'.&cc.'v.\+/'
"endif
"}}}

