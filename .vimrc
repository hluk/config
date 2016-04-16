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
set tabstop=4
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
" }}}

" PLUGINS {{{
" plugin loader (~/.vim/bundle/*)
" must be called before 'filetype indent on'
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'
" :BundleInstall to install new plugins
" :BundleInstall! to update plugins

" doxygen
au BufNewFile,BufReadPost *.cpp,*.c,*.h set syntax+=.doxygen

" qml
au BufRead,BufNewFile *.qml setfiletype javascript

" git commit message
au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])|set spell|set nosmartindent|set noautoindent|set nocindent

"" toggle comment (NERD commenter)
Bundle 'git://github.com/scrooloose/nerdcommenter.git'
map <C-\> <leader>c<SPACE>j
imap <C-\> <C-o><leader>c<SPACE><DOWN>

"" taglist
Bundle 'git://github.com/vim-scripts/taglist.vim.git'
noremap tt :TlistToggle<CR>

" Syntastic
Bundle 'git://github.com/scrooloose/syntastic.git'
nnoremap <F6> :Errors<CR>
let g:syntastic_mode_map = {
            \ 'mode': 'active',
            \ 'active_filetypes': [],
            \ 'passive_filetypes': ['c', 'cpp']
            \ }

" ctrlp - file/buffer finder
" C-p - open list
" C-z and C-o - mark files and open them
Bundle 'git://github.com/kien/ctrlp.vim.git'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_dotfiles = -1
let g:ctrlp_max_files = 5000
let g:ctrlp_max_depth = 6
let g:ctrlp_custom_ignore = 'build$'

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
"Bundle 'git://github.com/msanders/snipmate.vim.git'
" view/edit snippets; call ReloadAllSnippets() after editing
"noremap <C-n>n :execute 'sv ~/.vim/bundle/snipmate.vim/snippets/'.&ft.'.snippets'<CR>
"noremap <C-n>m :execute 'vs ~/.vim/snippets/'.&ft.'.snippets'<CR>
"noremap <C-n>r :call ReloadAllSnippets()<CR>

" fugitive (git)
Bundle 'git://github.com/tpope/vim-fugitive.git'
no gitd :Gd master<CR>

filetype plugin indent on

" Vim omnicompletion (intellisense) and more for c# http://www.omnisharp.net
Bundle 'git://github.com/OmniSharp/omnisharp-vim.git'
" Update server: cd ~/.vim/bundle/omnisharp-vim/omnisharp-roslyn && ./build.sh
let g:OmniSharp_selector_ui = 'ctrlp'
let g:OmniSharp_server_type = 'v1'
let g:OmniSharp_server_type = 'roslyn'

" asynchronous build and test dispatcher
Bundle 'git://github.com/tpope/vim-dispatch.git'

" Perform all your vim insert mode completions with Tab
Bundle 'https://github.com/ervandew/supertab'
let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"
let g:SuperTabDefaultCompletionTypeDiscovery = ["&omnifunc:<c-x><c-o>","&completefunc:<c-x><c-n>"]
let g:SuperTabClosePreviewOnPopupClose = 1
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
nmap <C-G> :echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')<CR>
"}}}

" CHANGE COLOR SCHEME {{{
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

" APPEARANCE {{{
" Bad Wolf color scheme
Bundle 'git://github.com/sjl/badwolf.git'

if has("gui_running")
    gui
    let &guicursor = &guicursor . ",a:blinkon0"
    "set guifont=Bitstream\ Vera\ Sans\ Mono\ 11.5
    "set guifont=DejaVu\ Sans\ Mono\ 11.5
    set guifont=Ubuntu\ Mono\ 11

    " zoom
    function! Zoom(how)
      let &guifont = substitute(&guifont, '[0-9.]\+$', '\=str2float(submatch(0))+' . string(a:how), '')
    endfunction
    map <C-F1> :execute Zoom(0.5)<CR>
    map <C-F2> :execute Zoom(-0.5)<CR>

    SetSchemes molokai soso wombat summerfruit256
else
    SetSchemes badwolf soso zenburn wombat256
endif

call SetScheme(0)
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

