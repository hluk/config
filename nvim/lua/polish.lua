vim.opt.wrap = true
vim.opt.spell = true

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

vim.opt.scrolloff=5

vim.opt.relativenumber = false

-- The default theme is based on current terminal background color
-- vim.opt.background = "dark"
-- vim.opt.background = "light"

vim.opt.completeopt = "menu,menuone,noselect,popup"

-- Folding is confusing and some documents get auto-folded
vim.wo.foldenable = false

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

-- Avoid modifying fugitive diff buffers
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = { "fugitive:///*//0/*" },
  callback = function()
    vim.opt_local.modifiable = false
    vim.opt_local.readonly = true
  end,
})

-- Strip trailing whitespace from yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    -- if vim.v.event.operator ~= "y" then return end

    local event = vim.v.event
    local reg = event.regname
    if reg == "" then reg = '"' end

    local cleaned = vim.tbl_map(function(line)
      return line:gsub("%s+$", "")
    end, event.regcontents)

    vim.fn.setreg(reg, cleaned, event.regtype)

    -- Sync to clipboard registers when clipboard option is active
    local cb = vim.opt.clipboard:get()
    local is_unnamed_reg = event.regname == ""
    if is_unnamed_reg then
      for _, v in ipairs(cb) do
        if v == "unnamedplus" then vim.fn.setreg("+", cleaned, event.regtype) end
        if v == "unnamed" then vim.fn.setreg("*", cleaned, event.regtype) end
      end
    end
  end,
})

vim.env.RIPGREP_CONFIG_PATH = vim.env.HOME .. "/.config/ripgreprc"

local cmp = require('cmp')
cmp.mapping.preset["<TAB>"] = vim.NIL

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

vim.api.nvim_set_keymap('i', '<C-l>', 'copilot#Accept("<CR>")', { expr=true, noremap = true, silent = true })

vim.api.nvim_create_user_command("CopyRelativePath", function()
  local path = vim.fn.expand("%:~:.")
  vim.fn.setreg("+", path)
  vim.notify('Path copied to clipobard:\n"' .. path .. '"', vim.log.levels.INFO)
end, {})
vim.api.nvim_set_keymap('n', '<C-g>', '', {
  noremap = true, silent = true,
  callback = vim.cmd.CopyRelativePath
})
vim.api.nvim_set_keymap('n', '<C-z>', '', {
  noremap = true, silent = true,
  callback = vim.cmd.ClangdSwitchSourceHeader
})
