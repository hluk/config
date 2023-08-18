return {
  { "LuaSnip", enabled = false },
  { "SchemaStore.nvim", enabled = false },
  { "alpha-nvim", enabled = false },
  { "flit.nvim", enabled = false },
  { "leap.nvim", enabled = false },
  { "mason-lspconfig.nvim", enabled = false },
  { "mason.nvim", enabled = false },
  { "mini.pairs", enabled = false },
  { "neoconf.nvim", enabled = false },
  { "null-ls.nvim", enabled = false },
  { "nvim-navic", enabled = false },
  { "nvim-notify", enabled = false },
  { "nvim-spectre", enabled = false },
  { "persistence.nvim", enabled = false },
  { "todo-comments.nvim", enabled = false },
  { "flash.nvim", enabled = false },

  -- handle line and column numbers in file names
  { "wsdjeg/vim-fetch" },

  -- Python - PEP 8
  { "nvie/vim-flake8", enabled = false },

  -- A collection of language packs for Vim.
  {
    "sheerun/vim-polyglot",
    init = function()
      vim.g.polyglot_disabled = { "autoindent", "markdown" }
    end,
  },

  { "Glench/Vim-Jinja2-Syntax" },

  -- file helpers:
  -- - :Mkdir, :Rename, :SudoWrite, ...
  -- - automatic chmod +x for new scripts
  { "tpope/vim-eunuch" },

  -- colorscheme
  { "EdenEast/nightfox.nvim" },
  { "ellisonleao/gruvbox.nvim" },

  {
    "which-key.nvim",
    opts = {
      plugins = { spelling = true },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
      spelling = true,
    },
  },
}
