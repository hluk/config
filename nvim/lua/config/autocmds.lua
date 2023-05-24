-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- update tab title in tmux
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "*" },
  callback = function()
    vim.fn.system("tmux rename-window " .. vim.fn.expand("%:p:gs?/home/[a-z]*/??"))
  end,
})
vim.api.nvim_create_autocmd({ "VimLeave" }, {
  pattern = { "*" },
  callback = function()
    -- https://github.com/neovim/neovim/issues/21856
    vim.fn.jobstart("tmux rename-window $(basename $SHELL)", {detach=true})
  end,
})
