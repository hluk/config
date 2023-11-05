-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
vim.opt.timeoutlen = 0

lvim.builtin.telescope.defaults.layout_config.width = 0.95
lvim.builtin.telescope.defaults.layout_config.height = 0.95
lvim.builtin.telescope.defaults.layout_strategy = 'horizontal'
lvim.keys.normal_mode["<leader><leader>"] = "<cmd>Telescope find_files<CR>"
lvim.keys.normal_mode["<leader>j"] = "<cmd>Telescope live_grep<CR>"

lvim.builtin.lualine.style = "default"
lvim.builtin.lualine.sections.lualine_c = {
  { "filename", path = 1 },
}

-- lvim.colorscheme = "catppuccin-latte"
lvim.colorscheme = "gruvbox"
vim.opt.background = "dark"

lvim.plugins = {
  -- Git
  {
    "tpope/vim-fugitive",
    config = function(_, opts)
      vim.api.nvim_create_user_command('Gbl', 'Git blame', {})
    end,
  },

  -- file helpers:
  -- - :Mkdir, :Rename, :SudoWrite, ...
  -- - automatic chmod +x for new scripts
  { "tpope/vim-eunuch" },

  -- colorscheme
  { "EdenEast/nightfox.nvim" },
  { "ellisonleao/gruvbox.nvim" },
  { "catppuccin/nvim" },
}

-- Restore cursor position in file
-- https://github.com/neovim/neovim/issues/16339#issuecomment-1457394370
vim.api.nvim_create_autocmd('BufRead', {
  callback = function(opts)
    vim.api.nvim_create_autocmd('BufWinEnter', {
      once = true,
      buffer = opts.buf,
      callback = function()
        local ft = vim.bo[opts.buf].filetype
        local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
        if
          not (ft:match('commit') and ft:match('rebase'))
          and last_known_line > 1
          and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
        then
          vim.api.nvim_feedkeys([[g`"]], 'nx', false)
        end
      end,
    })
  end,
})
