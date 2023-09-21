-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- update tab title in tmux
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "*" },
  callback = function()
    name = vim.fn.expand("%:t")
    vim.fn.system("tmux rename-window " .. name)
  end,
})
vim.api.nvim_create_autocmd({ "VimLeave" }, {
  pattern = { "*" },
  callback = function()
    -- https://github.com/neovim/neovim/issues/21856
    vim.fn.jobstart("tmux rename-window $(basename $SHELL)", {detach=true})
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "lua", "ruby", "eruby" },
  callback = function()
    vim.opt.shiftwidth = 2
    vim.opt.tabstop = 2
    vim.opt.softtabstop = 2
  end,
})
