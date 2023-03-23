return {
  --{ "leap.nvim", enabled = false },
  { "nvim-notify", enabled = false },
  { "mini.pairs", enabled = false },
  { "LuaSnip", enabled = false },

  -- fugitive (git)
  { "tpope/vim-fugitive" },

  -- handle line and column numbers in file names
  { "wsdjeg/vim-fetch" },

  -- Asynchronous Lint Engine
  { "dense-analysis/ale" },

  -- Python - PEP 8
  { "nvie/vim-flake8", enabled = false },

  -- A collection of language packs for Vim.
  { "sheerun/vim-polyglot" },

  -- Jinja2
  { "Glench/Vim-Jinja2-Syntax" },

  -- file helpers:
  -- - :Mkdir, :Rename, :SudoWrite, ...
  -- - automatic chmod +x for new scripts
  { "tpope/vim-eunuch" },

  -- colorscheme
  { "EdenEast/nightfox.nvim" },

  {
    "nvim-treesitter",
    opts = {
      ensure_installed = "all",
    },
  },

  {
    "which-key.nvim",
    opts = {
      plugins = { spelling = true },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "nightfox",
      spelling = true,
    },
  },
}
