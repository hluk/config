" USAGE:
" :read -- open file read only
" :setl ar -- automatically reload file if changed
" q/ -- search history
" q: -- command history
" gf -- open file which filename is under cursor
set nocompatible
set mouse=a
" save power
set nofsync
let &guicursor = &guicursor . ",a:blinkon0"
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
" highlight cursor line (slow!)
"set cursorline
" C indent
set cin
" cursor show next/prev parenthesis
set showmatch
" show pressed keys in lower right corner
set showcmd
"set backspace=indent,eol,start
set nojoinspaces
" clipboard
set clipboard=unnamed
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
"syntax
syntax on

" must be called before "filetype indent on"
filetype off
"call pathogen#runtime_append_all_bundles()

filetype plugin on
filetype indent on

set nobackup

command! Q :q
command! W :w

" faster commands
nnoremap ; :

" keep a 5 line buffer for the cursor from top/bottom of window
set scrolloff=5

"" toggle comment
map <C-C> <leader>c<SPACE>j
imap <C-C> <C-o><leader>c<SPACE><DOWN>

"" taglist
map TT :TlistToggle<CR>

"" NERDTree
map tt :NERDTreeToggle<CR>

let NERDShutUp=1

" make
map <F5> :make<CR>
imap <F5> <C-o>:make<CR>

" run/execute current file
map <C-CR> :w<CR>:!./%<CR>
imap <C-CR> <C-o>:w<CR><C-o>:!./%<CR>

" edit/reload configuration
map <C-e> :split ~/.vimrc <CR>
map <C-u> :source ~/.vimrc <CR>

" clear highlighted search term on space
noremap <silent> <Space> :silent noh<Bar>echo<CR>

" Get arrow keys and j/k to work on screen lines, rather than document lines. {{{
"nmap <up>    gk
"nmap <down>  gj
"nmap k       gk
"nmap j       gj
"imap <up>   <esc>gka
"imap <down> <esc>gja
"}}}

" Completion {{{
"let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
let g:SuperTabDefaultCompletionType = "context"

let g:acp_completeoptPreview = 1

set wildignore=*.o,*.pyc           " don't complete on files you never need to open

imap <C-Space> <C-X><C-O>

" Completion popup menu like in an IDE (Matt Zyzik)
set completeopt=longest,menuone,preview
"inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"
"inoremap <expr> <c-n> pumvisible() ? "\<lt>c-n>" : "\<lt>c-n>\<lt>c-r>=pumvisible() ? \"\\<lt>down>\" : \"\"\<lt>cr>" 
"inoremap <expr> <m-;> pumvisible() ? "\<lt>c-n>" : "\<lt>c-x>\<lt>c-o>\<lt>c-n>\<lt>c-p>\<lt>c-r>=pumvisible() ? \"\\<lt>down>\" : \"\"\<lt>cr>"

"inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
"inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
"inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
"inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
"inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
"inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"
"}}}

" Dictionary Word Completion Using C-x C-k {{{
set dictionary+=/usr/share/dict/words
"" spell checking
"set spelllang=cs
map <F7> :set spell<CR>
map <S-F7> :set nospell<CR>
" spell keys
map <F6> :w<CR>:!LANG=cs_CZ.iso-8859-2 aspell -t -x --lang=cs -c %<CR>:<CR>:e<CR><CR>k
imap <F6> <ESC>:w<CR>:!LANG=cs_CZ.iso-8859-2 aspell -t -x --lang=cs -c %<CR>:e<CR><CR>ki
"}}}

" FOLDS {{{
set foldmethod=marker
"set foldmethod=syntax
"}}}

" TABS {{{
map tn :tabnew<space>
map td :tabclose<CR>
map [5;5~ :tabprev<CR>
map [6;5~ :tabnext<CR>
map [1;5D :tabprev<CR>
map [1;5C :tabnext<CR>
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
" close buffer
map <F4> :bd<CR>
"}}}

" filetype-specific config {{{
autocmd FileType c    set tags+=~/.vim/tags_c
autocmd FileType c    set omnifunc=ccomplete#Complete
autocmd FileType cpp  set omnifunc=ccomplete#Complete
autocmd FileType cpp  set tags+=~/.vim/tags_cpp
autocmd FileType ruby set tags+=~/.vim/tags_ruby
autocmd FileType java set tags+=~/.vim/tags_java
autocmd FileType python set noexpandtab
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set filetype+=.doxygen
"set tags+=~/.vim/ctags
autocmd FileType c noremap <C-F12> :!ctags -R --c-kinds=+p --fields=+iaS --extra=+q --language-force=C 
autocmd FileType c noremap <F12> :!ctags -R --c-kinds=+p --fields=+iaS --extra=+q --language-force=C .<CR>
autocmd FileType cpp noremap <F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++ .<CR>
"noremap <F12> :!exuberant-ctags -R .<CR>
"autocmd FileType ruby noremap <F11> :!exuberant-ctags --totals --lang-map=Ruby:+.rb -f ~/.vim/tags_ruby -R /usr/lib/ruby/gems /usr/lib/ruby/site_ruby<CR>

autocmd FileType haskell set expandtab

" markdown
autocmd BufNewFile,BufRead *.md set filetype=markdown
"}}}

" save {{{
map <F2> :w<CR>
imap <F2> <C-o>:w<CR>
map <C-S> :w<CR>
imap <C-S> <C-o>:w<CR>
" save session and quit
map <C-q> :mksession!<CR>:qa<CR>
imap <C-q> <C-o>:mksession!<CR><C-o>:qa<CR>
"}}}

" HEX {{{
command! Xxd :%!xxd
command! Xxdr :%!xxd -r
"}}}

" zoom {{{
function! Zoom(how)
  let &guifont = substitute(&guifont, '[0-9.]\+$', '\=str2float(submatch(0))+' . string(a:how), '')
endfunction

map <C-F1> :execute Zoom(0.5)<CR>
map <C-F2> :execute Zoom(-0.5)<CR>
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
"   :SetColors all              (all $VIMRUNTIME/colors/*.vim)
"   :SetColors blue slate ron   (these schemes)
"   :SetColors                  (display current scheme names)

" Set list of color scheme names that we will use, except
" argument 'now' actually changes the current color scheme.
function! s:SetColors(args)
  if len(a:args) == 0
    echo 'Current color scheme names:'
    let i = 0
    while i < len(s:mycolors)
      echo '  '.join(map(s:mycolors[i : i+4], 'printf("%-14s", v:val)'))
      let i += 5
    endwhile
  elseif a:args == 'all'
    let paths = split(globpath(&runtimepath, 'colors/*.vim'), "\n")
    let s:mycolors = map(paths, 'fnamemodify(v:val, ":t:r")')
    echo 'List of colors set from all installed color schemes'
  else
    let s:mycolors = split(a:args)
    echo 'List of colors set from argument (space-separated names)'
  endif
endfunction

command! -nargs=* SetColors call <SID>SetColors('<args>')

function! NextColor(how)
  if len(s:mycolors) == 0
    call s:SetColors('all')
  endif
  if exists('s:mycolor')
    let current = index(s:mycolors, s:mycolor)
  else
    let current = -1
  endif
  let missing = []
  let how = a:how
  for i in range(len(s:mycolors))
    let current += how
    if !(0 <= current && current < len(s:mycolors))
      let current = (how>0 ? 0 : len(s:mycolors)-1)
    endif
    try
      let s:mycolor=s:mycolors[current]
      execute 'colorscheme '.s:mycolor
      break
   catch /E185:/
      call add(missing, s:mycolors[current])
    endtry
  endfor
  redraw
  if len(missing) > 0
    echo 'Error: colorscheme not found:' join(missing)
  endif
  echo s:mycolor
endfunction

" Set color scheme according to current time of day.
function! HourColor()
  let hr = str2nr(strftime('%H'))
  if hr <= 6
    set background=dark
    let i = 0
  elseif hr <= 7
    set background=light
    let i = 1
  elseif hr <= 15
    set background=light
    let i = 2
  elseif hr <= 17
    set background=light
    let i = 3
  else
    set background=dark
    let i = 4
  endif
  let s:mycolor=s:mycolors[i]
  execute 'colorscheme '.s:mycolor
endfunction

nnoremap <F9> :call NextColor(1)<CR>
nnoremap <F8> :call NextColor(-1)<CR>
inoremap <F9> <C-o>:call NextColor(1)<CR>
inoremap <F8> <C-o>:call NextColor(-1)<CR>
"}}}

" GUI/console appearance {{{
let s:mycolor='soso'
if has("gui_running")
    gui
    set guifont=Bitstream\ Vera\ Sans\ Mono\ 9

    let s:mycolors = ['solarized', 'soso', 'wombat', 'molokai', 'summerfruit256']
    call HourColor()
else
    let s:mycolors = ['zenburn', 'autumn2', 'soso', 'mustang', 'wombat256', 'xoria256']
    call HourColor()
endif
"}}}

" screen
nmap \| :!screen<CR>

" visually differentiate normal and insert modes"{{{
"let s:n_laststatus=&laststatus
function! ModeEntered(mode)
    if a:mode == 'i'
        "let s:n_laststatus=&laststatus
        "set laststatus=2

        "hi StatusLine term=reverse ctermfg=black ctermbg=green
        "hi LineNr ctermfg=black ctermbg=green

        set cursorline
        "set cursorcolumn
    else
        "let &laststatus=s:n_laststatus

        "execute 'colorscheme '.s:mycolor

        set nocursorline
        "set nocursorcolumn
    endif
endfunction

"au InsertEnter * set cursorline
"au InsertLeave * set nocursorline
au InsertEnter * call ModeEntered('i')
au InsertLeave * call ModeEntered('n')
" cursor in Konsole for normal and insert mode
"let &t_SI = "\<Esc>]50;CursorShape=1\x7"
"let &t_EI = "\<Esc>]50;CursorShape=0\x7"
"}}}

set colorcolumn=81

