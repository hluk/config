return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        -- first key is the mode
        n = {
          -- second key is the lefthand side of the map
          -- mappings seen under group name "Buffer"
          --
          ["<leader><leader>"] = {":lua require('telescope.builtin').find_files { shorten_path = true }<CR>", desc = "Find Files"},
          ["<leader>j"] = {"<cmd>Telescope grep_string search=<CR>", desc = "Grep Files"},
        },
        t = {
          -- setting a mapping to false will disable it
          -- ["<esc>"] = false,
        },
      },
    },
  },
}
