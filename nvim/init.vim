" USAGE:
" :h index
" :options
" :read -- open file read only
" :setl ar -- automatically reload file if changed
" :windo difft -- diff open files
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
"
" :args **/*.h | vert sall -- open all matching files
"
" :'<,'>norm @r -- run a macro on each line in selection
" :'<,'>norm . -- repeat last change on each line in selection
"
" :!ctags -R . /usr/include/X11/ /usr/include/qt5/ -- generate ctags
" S-k -- open manual page for symbol under cursor
"
" http://vimbits.com/bits?sort=top
" https://www.reddit.com/r/vim/wiki/vimrctips

" OPTIONS {{{
" highlight matched
set hlsearch
" command history size
set history=512
" case insensitive search
set ignorecase
set smartcase
" search while typing
set incsearch
" shows the effects of a command as you type
set inccommand=nosplit
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
set tabstop=4
" keep a 5 line buffer for the cursor from top/bottom of window
set scrolloff=5
" X11 clipboard
set clipboard=unnamed,unnamedplus
" use ~ with movement
set tildeop
" persistent undo history
call system('mkdir -p ~/.config/nvim/undofiles/')
set undodir=~/.config/nvim/undofiles/
set undofile
autocmd OptionSet guicursor noautocmd set guicursor=

" disable per-file configuration
set nomodeline

" automatically reload changed file
set autoread

" show tabs and trailing whitespace
set list listchars=tab:>·,trail:~

" Fix resetting nopaste after pasting. (The issue breaks expandtab config.)
" Fixed in version v0.4.2.
" See: https://github.com/neovim/neovim/issues/7994
au InsertLeave * set nopaste

set termguicolors

set foldmethod=marker
set foldnestmax=2

set showtabline=2

let mapleader = ","
" }}}

" FILES {{{
" update tab title in tmux
autocmd BufEnter * call system("tmux rename-window " . expand("%:p:gs?/home/[a-z]*/??"))
autocmd VimLeave * call system("tmux rename-window $(basename $SHELL)")

" Restore open folds
augroup restore_folds
  autocmd!
  autocmd BufWinLeave *.* mkview 1
  autocmd BufWinEnter *.* silent! loadview 1
augroup END

" python
"autocmd BufWritePost *.py silent :!darker %
autocmd BufRead,BufNewFile *.py setlocal foldmethod=indent

" doxygen
autocmd BufNewFile,BufReadPost *.cpp,*.c,*.h set syntax+=.doxygen

" qml
autocmd BufRead,BufNewFile *.qml setfiletype javascript

" Jenkinsfile
autocmd BufRead,BufNewFile *Jenkinsfile* setfiletype groovy

" git commit message
autocmd FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])|set spell|set nosmartindent|set noautoindent|set nocindent

" json
autocmd BufRead,BufNewFile *.json setlocal ts=2 sts=2 sw=2 expandtab

" yaml
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd BufRead,BufNewFile ~/.config/yamllint/config setfiletype yaml
autocmd BufRead,BufNewFile */ansible/inventory/* setfiletype yaml

" lua
autocmd FileType lua setlocal ts=2 sts=2 sw=2 expandtab

" go
autocmd FileType go setlocal ts=4 sts=4 sw=4 noexpandtab

" ruby
autocmd FileType ruby setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType eruby setlocal ts=2 sts=2 sw=2 expandtab

" meson
autocmd BufRead,BufNewFile meson.build setlocal ts=2 sts=2 sw=2 expandtab

" elixir
autocmd FileType elixir setlocal formatprg=mix\ format\ -

" fedpkg update (Bodhi update configuration)
autocmd BufRead,BufNewFile bodhi.template setlocal filetype=toml
" }}}

" PLUGINS {{{
" https://github.com/junegunn/vim-plug
"   curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" :PlugInstall to install new plugins
" :PlugUpdate to update plugins
" :PlugUpgrade to upgrade vim-plug
call plug#begin('~/.config/nvim/plugged')

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
"Plug 'SirVer/ultisnips'
"Plug 'honza/vim-snippets'
"let g:UltiSnipsExpandTrigger="<tab>"

" fugitive (git)
Plug 'tpope/vim-fugitive'
command Gbl Git blame

" asynchronous build and test dispatcher
Plug 'tpope/vim-dispatch'

" file helpers:
" - :Mkdir, :Rename, :SudoWrite, ...
" - automatic chmod +x for new scripts
Plug 'tpope/vim-eunuch'

" Python
" PEP 8
Plug 'nvie/vim-flake8'

" A collection of language packs for Vim.
Plug 'sheerun/vim-polyglot'
let g:polyglot_disabled = ['markdown']
" Rust syntax
"Plug 'rust-lang/rust.vim'
" Go
"Plug 'fatih/vim-go'
" meson
"Plug 'igankevich/mesonic'
" jsonnet
"Plug 'google/vim-jsonnet'
"autocmd BufRead,BufNewFile *.jsonnet setlocal ts=2 sts=2 sw=2 expandtab

" Ruby on Rails
"Plug 'tpope/vim-rails'

" Jinja2
Plug 'Glench/Vim-Jinja2-Syntax'

" Nim
Plug 'alaviss/nim.nvim'

" fzf
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }
let g:fzf_preview_window = ['right:50%', 'ctrl-/']
let g:fzf_history_dir = '~/.local/share/fzf-history'
let $FZF_DEFAULT_COMMAND = 'rg --files'
let $RIPGREP_CONFIG_PATH = $HOME .. '/.config/ripgreprc'
noremap <c-t> :Files<CR>
noremap <c-k> :Files<CR>
noremap <c-g> :Rg!<CR>
noremap <c-j> :Buffers<CR>
noremap <c-l> :Tags<CR>
" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" Color schemes
Plug 'sjl/badwolf'
Plug 'morhetz/gruvbox'
Plug 'catppuccin/nvim'
Plug 'rose-pine/neovim'
Plug 'EdenEast/nightfox.nvim'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }

" reopen files at your last edit position
Plug 'farmergreg/vim-lastplace'

Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'

" completion
"Plug 'neovim/nvim-lspconfig'
"Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'tzachar/cmp-tabnine', { 'do': './install.sh' }

" handle line and column numbers in file names
Plug 'wsdjeg/vim-fetch'

"Plug 'psf/black'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'

call plug#end()
" }}}

" LUA {{{
lua <<LUA_END
local cmp = require('cmp')
cmp.setup({
    sources = {{ name = 'buffer' }},
    completion = {
        autocomplete = {
            require('cmp.types').cmp.TriggerEvent.InsertEnter,
            require('cmp.types').cmp.TriggerEvent.TextChanged
        }
    }
})
cmp.setup.cmdline('/', {
  sources = {{ name = 'buffer' }}
})
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

require('cmp_tabnine.config'):setup({
    max_lines = 1000;
    max_num_results = 20;
    sort = true;
    run_on_every_keystroke = true;
    snippet_placeholder = '..';
    ignored_file_types = { -- default is not to ignore
        -- uncomment to ignore in lua:
        -- lua = true
    };
})

require('nvim-treesitter.configs').setup {
    ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
    textobjects = {
        select = {
            enable = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["ab"] = "@block.outer",
                ["ib"] = "@block.inner",
                ["aa"] = "@parameter.outer",
                ["ia"] = "@parameter.inner",
                },
            },
        move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]b"] = "@block.outer",
                ["]a"] = "@parameter.outer",
                },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]B"] = "@block.outer",
                ["]A"] = "@parameter.outer",
                },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[b"] = "@block.outer",
                ["[a"] = "@parameter.outer",
                },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[B"] = "@block.outer",
                ["[A"] = "@parameter.outer",
                },
            },
    },
}
require'lualine'.setup {
  sections = {
    lualine_a = {'mode'},
    lualine_b = {
      'branch',
      'diff',
      {'diagnostics', sources = {'nvim_diagnostic', 'coc'}},
    },
    lualine_c = {{'filename', path=1}},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {{'filename', path=1}},
    lualine_c = {},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {
    lualine_a = {{
      'buffers',
      show_filename_only=false,
      mode=2,
      max_length = vim.o.columns
    }},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
}
LUA_END
" }}}

" KEYS {{{
" faster commands
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

" typos
command! Q :q
command! Qa :qa
command! W :w
command! Wq :wq
command! WQ :wq

" buffers
nnoremap <Leader>l :ls<CR>
nnoremap <Leader>b :bp<CR>
nnoremap <Leader>f :bn<CR>
nnoremap <Leader>g :e#<CR>
nnoremap <Leader>1 :1b<CR>
nnoremap <Leader>2 :2b<CR>
nnoremap <Leader>3 :3b<CR>
nnoremap <Leader>4 :4b<CR>
nnoremap <Leader>5 :5b<CR>
nnoremap <Leader>6 :6b<CR>
nnoremap <Leader>7 :7b<CR>
nnoremap <Leader>8 :8b<CR>
nnoremap <Leader>9 :9b<CR>
nnoremap <Leader>0 :10b<CR>
" Ngb jumps to specific buffer
let c = 1
while c <= 99
  execute "nnoremap " . c . "gb :" . c . "b\<CR>"
  let c += 1
endwhile

" edit/source configuration
noremap <C-e>e :split ~/.config/nvim/init.vim <CR>
noremap <C-e>r :source ~/.config/nvim/init.vim <CR>

" clear highlighted search term on space
noremap <silent> <Space> :nohlsearch<CR>

" reselect visual block after indent
vnoremap < <gv
vnoremap > >gv

inoremap jj <Esc>

nnoremap Q <Nop>

"tnoremap <Esc> <C-\><C-n>
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

tnoremap <A-S-h> <C-\><C-N><C-w><S-h>
tnoremap <A-S-j> <C-\><C-N><C-w><S-j>
tnoremap <A-S-k> <C-\><C-N><C-w><S-k>
tnoremap <A-S-l> <C-\><C-N><C-w><S-l>
inoremap <A-S-h> <C-\><C-N><C-w><S-h>
inoremap <A-S-j> <C-\><C-N><C-w><S-j>
inoremap <A-S-k> <C-\><C-N><C-w><S-k>
inoremap <A-S-l> <C-\><C-N><C-w><S-l>
nnoremap <A-S-h> <C-w><S-h>
nnoremap <A-S-j> <C-w><S-j>
nnoremap <A-S-k> <C-w><S-k>
nnoremap <A-S-l> <C-w><S-l>
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
set completeopt=menu,menuone,noselect
"}}}

" DICTIONARY (C-x C-k) {{{
"set dictionary+=/usr/share/dict/words
"set spelllang=cs
map <F7> :set spell!<CR>
set spell
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

" gruvbox color theme
"https://github.com/morhetz/gruvbox/wiki/Configuration
"let g:gruvbox_italic=1
"let g:gruvbox_contrast_dark='hard'
"let g:gruvbox_contrast_light='hard'
"let g:gruvbox_improved_strings=0
"colorscheme gruvbox

"colorscheme duskfox
"colorscheme nightfox
"colorscheme rose-pine
"colorscheme catppuccin
colorscheme tokyonight
"}}}
