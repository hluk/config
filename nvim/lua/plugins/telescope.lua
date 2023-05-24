return {
  {
    "nvim-telescope/telescope.nvim",
    enabled = false,
    cmd = "Telescope",
    version = false,
    keys = {
      { "<leader>t", "<cmd>Telescope grep_string search=<cr>", desc = "Word (root dir)" },
    },
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
    opts = {
      defaults = {
        file_ignore_patterns = {
          "^.mypy_cache/",
          "^.tox/",
          "^.venv/",
          "^tags$",
          "^venv/",
        },
      },
    },
  },
}
