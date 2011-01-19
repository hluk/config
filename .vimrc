" USAGE:
" :read -- open file read only
" :setl ar -- automatically reload file if changed
" q/ -- search history
" q: -- command history
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
call pathogen#runtime_append_all_bundles()

filetype plugin on
filetype indent on

"" Get arrow keys and j/k to work on screen lines, rather than document lines.
"nmap <up>    gk
"nmap <down>  gj
"nmap k       gk
"nmap j       gj
"imap <up>   <esc>gka
"imap <down> <esc>gja

"" Make Vim completion popup menu work just like in an IDE (Matt Zyzik)
set completeopt=longest,menuone,preview
"inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"
"inoremap <expr> <c-n> pumvisible() ? "\<lt>c-n>" : "\<lt>c-n>\<lt>c-r>=pumvisible() ? \"\\<lt>down>\" : \"\"\<lt>cr>" 
"inoremap <expr> <m-;> pumvisible() ? "\<lt>c-n>" : "\<lt>c-x>\<lt>c-o>\<lt>c-n>\<lt>c-p>\<lt>c-r>=pumvisible() ? \"\\<lt>down>\" : \"\"\<lt>cr>"
inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"

"" Dictionary Word Completion Using C-x C-k
set dictionary+=/usr/share/dict/words
"" spell checking
"set spelllang=cs
map <F7> :set spell<CR>
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
map tn :tabnew<space>
map td :tabclose<CR>
map [5;5~ :tabprev<CR>
map [6;5~ :tabnext<CR>
map <C-Tab> :tabnext<CR>
map <S-C-Tab> :tabprev<CR>
imap <C-Tab> :tabnext<CR>
imap <S-C-Tab> :tabprev<CR>
imap <C-Tab> <C-o>:tabnext<CR>
imap <S-C-Tab> <C-o>:tabprev<CR>

"" windows
map <TAB> <C-W><C-W>
map <S-TAB> <C-W><S-W>
"let g:miniBufExplMapCTabSwitchBufs = 1
"imap <C-Tab> <C-o><C-Tab>
"imap <S-C-Tab> <C-o><S-C-Tab>
" close buffer
map <F4> :bd<CR>

"" toggle comment
map <C-C> ,c<SPACE>j
imap <C-C> <C-o>,c<SPACE><DOWN>

"" taglist
map TT :TlistToggle<CR>

"" NERDTree
map tt :NERDTreeToggle<CR>

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

" KEYS
" save
map <F2> :w<CR>
imap <F2> <C-o>:w<CR>
map <C-S> :w<CR>
imap <C-S> <C-o>:w<CR>
" save session and quit
map <C-q> :mksession!<CR>:qa<CR>
imap <C-q> <C-o>:mksession!<CR><C-o>:qa<CR>
" make
map <F5> :make<CR>
imap <F5> <C-o>:make<CR>

" omni-completion shortcut alias
"imap <Tab> <C-X><C-O>
imap <C-Space> <C-X><C-O>

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

" view tabs and trailing spaces
"set list
"set listchars=tab:»·,trail:·

let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
let g:SuperTabDefaultCompletionType = "context"

let g:acp_completeoptPreview = 1

"{{{Theme Rotating
let themeindex=0
function! RotateColorTheme()
    let y = -1
    while y == -1
        if has("gui_running")
            let colorstring = "#wombat#summerfruit256#soso#tango2#no_quarter#molokai#xoria256#default#"
        else
            let colorstring = "#wombat256#default#summerfruit#molokai#xoria256#soso#256-jungle#"
        endif

        let x = match( colorstring, "#", g:themeindex )
        let y = match( colorstring, "#", x + 1 )
        let g:themeindex = x + 1
        if y == -1
            let g:themeindex = 0
        else
            let themestring = strpart(colorstring, x + 1, y - x - 1)
            return ":colorscheme ".themestring
        endif
    endwhile
endfunction

nnoremap <silent> <F8> :execute RotateColorTheme()<CR>
" }}}

"{{{
if !exists("g:change_color_scheme")
    let g:sep='?'

    function! ElementAt (array, sep, index)
        if strlen(a:array) == 0 || a:index < 0
            return -1
        endif

        let current_pos = 0 	" current character position within array
        let i = 0		" current array position

        " Search the array element on a:index position.
        while i != a:index
            let current_pos = match(a:array, a:sep, current_pos)
            if current_pos == -1
                return -1	" couldn't find it
            endif

            let current_pos = current_pos + 1
            let i = i + 1
        endwhile
        
	" then find where the current array element ends
        let array_element_endpos = match(a:array, a:sep, current_pos)
        if array_element_endpos == -1
	    " must be the last array element
	    let array_element_endpos = strlen(a:array)
	endif

        " return the color scheme file path in a:index position
        return strpart(a:array,current_pos,(array_element_endpos-current_pos))
    endfunction  " ElementAt


    " If g:colors_name is defined, return the name of current color syntax name.
    " Otherwise return an empty string
    function! GetColorSyntaxName()
        if exists('g:colors_name')
            return g:colors_name
        else
            return ''
        endif
    endfunction  "GetColorSyntaxName

    let g:change_color_scheme="0.1"
endif

let s:color_schemes = substitute(globpath(&runtimepath,"colors/*.vim"), '\n', g:sep, 'g')
let s:total_schemes = 0
let s:scheme_index = 0

if (strlen(s:color_schemes) > 0)
    let found = 0
    while found != -1
        let found = match(s:color_schemes, g:sep, found+1)
        let s:total_schemes = s:total_schemes + 1
    endwhile
endif

function! NextColorScheme()
    let s:scheme_index = s:scheme_index + 1
    call LoadColorScheme()
endfunction

function! PreviousColorScheme()
    let s:scheme_index = s:scheme_index - 1
    call LoadColorScheme()
endfunction

function! LoadColorScheme()
    " quit if there's no color scheme
    if s:total_schemes == 0
    	    return 0
    endif

    " wrap around scheme_index for either direction
    if s:scheme_index < 0 
        let s:scheme_index = s:total_schemes-1
    elseif s:scheme_index >= s:total_schemes
        let s:scheme_index = 0
    endif

    " ElementAt returns the name of color scheme on scheme_index position in
    " color_schemes array. Then we will load (source) the scheme.
    exe "source " ElementAt(s:color_schemes, g:sep, s:scheme_index)
endfunction

map <F11>   :call NextColorScheme()<CR>
map <S-F11> :call PreviousColorScheme()<CR>
"set rulerformat=%55(%{g:colors_name}\ %5l,%-6(%c%V%)\ %P%)
"set rulerformat=%55(%{GetColorSyntaxName()}\ %5l,%-6(%c%V%)\ %P%)
"}}}

if has("gui_running")
	"gui
    set guifont=Bitstream\ Vera\ Sans\ Mono\ 8.5
    "set guifont=Liberation\ Mono\ 11
    "set guifont=Monospace\ 11
    "set guifont=Inconsolata\ 11
    "set guifont=Consolas\ 13
    "set guifont=monofur\ 13
    "set guifont=Envy\ Code\ R\ 9
    "set guifont=DejaVu\ Sans\ Mono\ 10

    colorscheme default

    "colorscheme wombat
	"colorscheme xoria256
	
	"colorscheme rainbow_breeze
	
	"colorscheme soso
	"colorscheme khaki
else
	"colorscheme redblack
	"colorscheme 256-jungle
	"colorscheme molokai
	colorscheme wombat256
	"colorscheme kellys
	
	"colorscheme calmar256-light
	"colorscheme khaki
	"colorscheme soso
endif

set wildignore=*.o,*.pyc           " don't complete on files you never need to open
set scrolloff=5                    " keep a 5 line buffer for the cursor from top/bottom of window
" clear highlighted search term on space
noremap <silent> <Space> :silent noh<Bar>echo<CR>
set nobackup

" faster commands
nnoremap ; :

" run/execute current file
map <C-CR> :w<CR>:!./%<CR>
imap <C-CR> <C-o>:w<CR><C-o>:!./%<CR>

" zoom"{{{
function! Zoom(how)
  let &guifont = substitute(&guifont, '[0-9.]\+$', '\=str2float(submatch(0))+' . string(a:how), '')
endfunction

map <C-F1> :execute Zoom(0.5)<CR>
map <C-F2> :execute Zoom(-0.5)<CR>
"}}}

" Show syntax highlighting groups for word under cursor
nmap <C-S-P> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

