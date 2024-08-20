---@type LazySpec
return {
  -- Git
  {
    "tpope/vim-fugitive",
    config = function(_, opts)
      vim.api.nvim_create_user_command('Gbl', 'Git blame', {})
    end,
  },

  -- cycle through diffs
  -- :DiffviewFileHistory %
  { "sindrets/diffview.nvim" },

  -- handle line and column numbers in file names
  { "wsdjeg/vim-fetch" },

  -- file helpers:
  -- - :Mkdir, :Rename, :SudoWrite, ...
  -- - automatic chmod +x for new scripts
  { "tpope/vim-eunuch" },

  -- colorscheme
  { "EdenEast/nightfox.nvim" },
  { "ellisonleao/gruvbox.nvim" },
  { "catppuccin/nvim" },

  -- -- Structural search and replace
  -- {
  --   "cshuaimin/ssr.nvim",
  --   lazy = true,
  --   -- Calling setup is optional.
  --   config = function()
  --     require("ssr").setup {
  --       border = "rounded",
  --       min_width = 50,
  --       min_height = 5,
  --       max_width = 120,
  --       max_height = 25,
  --       adjust_window = true,
  --       keymaps = {
  --         close = "q",
  --         next_match = "n",
  --         prev_match = "N",
  --         replace_confirm = "<cr>",
  --         replace_all = "<leader><cr>",
  --       },
  --     }
  --   end
  -- },

  -- {
  --   "mfussenegger/nvim-dap",
  --   lazy = true,
  --   config = function()
  --       local dap = require('dap')
  --       -- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
  --       dap.adapters.gdb = {
  --           type = 'executable',
  --           command = 'gdb',
  --           args = { '--quiet', '--interpreter=dap' },
  --       }
  --       dap.adapters.lldb = {
  --           type = 'executable',
  --           command = 'lldb-vscode',
  --       }
  --       dap.configurations.cpp = {
  --           {
  --               name = 'Run',
  --               type = 'lldb',
  --               request = 'launch',
  --               program = function()
  --                   local path = vim.fn.input({
  --                       prompt = 'Path to executable: ',
  --                       default = vim.fn.getcwd() .. '/',
  --                       completion = 'file',
  --                   })
  --                   return (path and path ~= "") and path or dap.ABORT
  --               end,
  --               args = function()
  --                   local args = vim.fn.input({
  --                       prompt = 'Arguments: ',
  --                       default = '',
  --                   })
  --                   return vim.split(args, ' ')
  --               end,
  --           },
  --           {
  --               name = 'Attach',
  --               type = 'lldb',
  --               request = 'attach',
  --               processId = require('dap.utils').pick_process,
  --           },
  --       }
  --   end
  -- },
}
