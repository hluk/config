-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
vim.opt.timeoutlen = 0

vim.opt.mouse = ""
vim.opt.wrap = true

lvim.builtin.project.manual_mode = true
lvim.builtin.telescope.defaults.layout_config.width = 0.95
lvim.builtin.telescope.defaults.layout_config.height = 0.95
lvim.builtin.telescope.defaults.layout_strategy = 'horizontal'
lvim.builtin.telescope.pickers.find_files.hidden = true
lvim.builtin.telescope.pickers.git_files.hidden = true
lvim.builtin.telescope.pickers.git_files.show_untracked = true
lvim.builtin.telescope.pickers.grep_string.only_sort_text = true
lvim.builtin.telescope.pickers.live_grep.only_sort_text = true
lvim.builtin.telescope.defaults.path_display = {"truncate"}
lvim.builtin.telescope.defaults.file_ignore_patterns = {".git/", ".venv/", "build/"}
lvim.keys.normal_mode["<leader><leader>"] = ":lua require('telescope.builtin').find_files { shorten_path = true }<CR>"
lvim.keys.normal_mode["<leader>j"] = "<cmd>Telescope grep_string search=<CR>"
lvim.keys.normal_mode["<leader>ss"] = function() require("ssr").open() end
lvim.keys.visual_mode["<leader>ss"] = function() require("ssr").open() end

lvim.builtin.lualine.style = "default"
lvim.builtin.lualine.sections.lualine_c = {
  { "filename", path = 1 },
}

lvim.builtin.treesitter.ensure_installed = "all"
lvim.builtin.treesitter.ignore_install = { "" }
lvim.builtin.treesitter.highlight = {
    enable = true,
    disable = { "" },
}
lvim.builtin.treesitter.indent = {
    enable = true,
    disable = { "c", "cpp", "go" },
}
lvim.builtin.treesitter.context_commentstring = {
    enable = true,
}

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "cpp", "c", "go", "sh" },
  callback = function()
    vim.opt.shiftwidth = 4
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "go" },
  callback = function()
    vim.opt.expandtab = false
  end,
})

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

  -- cycle through diffs
  -- :DiffviewFileHistory %
  { "sindrets/diffview.nvim"},

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

  -- Structural search and replace
  {
    "cshuaimin/ssr.nvim",
    lazy = true,
    -- Calling setup is optional.
    config = function()
      require("ssr").setup {
        border = "rounded",
        min_width = 50,
        min_height = 5,
        max_width = 120,
        max_height = 25,
        adjust_window = true,
        keymaps = {
          close = "q",
          next_match = "n",
          prev_match = "N",
          replace_confirm = "<cr>",
          replace_all = "<leader><cr>",
        },
      }
    end
  },

  {
    "mfussenegger/nvim-dap",
    lazy = true,
    config = function()
        local dap = require('dap')
        -- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
        dap.adapters.gdb = {
            type = 'executable',
            command = 'gdb',
            args = { '--quiet', '--interpreter=dap' },
        }
        dap.adapters.lldb = {
            type = 'executable',
            command = 'lldb-vscode',
        }
        dap.configurations.cpp = {
            {
                name = 'Run',
                type = 'lldb',
                request = 'launch',
                program = function()
                    local path = vim.fn.input({
                        prompt = 'Path to executable: ',
                        default = vim.fn.getcwd() .. '/',
                        completion = 'file',
                    })
                    return (path and path ~= "") and path or dap.ABORT
                end,
                args = function()
                    local args = vim.fn.input({
                        prompt = 'Arguments: ',
                        default = '',
                    })
                    return vim.split(args, ' ')
                end,
            },
            {
                name = 'Attach',
                type = 'lldb',
                request = 'attach',
                processId = require('dap.utils').pick_process,
            },
        }
    end
  },
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
