vim.opt.mouse = ""
vim.opt.wrap = true
vim.opt.spell = true

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

vim.opt.scrolloff=5

vim.opt.relativenumber = false

-- Always show command line and suppress "Press ENTER or type command to
-- continue" messages
vim.opt.cmdheight = 1

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "yaml", "json", "jsonnet" },
  callback = function()
    vim.opt.shiftwidth = 2
    vim.opt.tabstop = 2
    vim.opt.softtabstop = 2
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "go" },
  callback = function()
    vim.opt.expandtab = false
  end,
})

vim.env.RIPGREP_CONFIG_PATH = vim.env.HOME .. "/.config/ripgreprc"

local actions = require "telescope.actions"
require("telescope").setup {
  pickers = {
    find_files = {
      hidden = true,
      file_ignore_patterns = {
        "^.git/",
        "^.mypy_cache/",
        "^.tox/",
        "^.venv/",
        "^tags$",
        "^venv/",
      },
    },
  },
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = actions.cycle_history_next,
        ["<C-k>"] = actions.cycle_history_prev,
      }
    }
  }
}
