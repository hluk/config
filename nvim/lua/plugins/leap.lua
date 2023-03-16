return {
  {
    "ggandor/leap.nvim",
    keys = {
      { "gl", mode = { "n", "x", "o" }, desc = "Leap forward to" },
      { "gh", mode = { "n", "x", "o" }, desc = "Leap backward to" },
      { "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
    },
    config = function(_, opts)
      local leap = require("leap")
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      leap.add_default_mappings(true)
      vim.keymap.del({ "x", "o" }, "x")
      vim.keymap.del({ "x", "o" }, "X")

      vim.api.nvim_del_keymap("n", "s")
      vim.api.nvim_del_keymap("x", "s")
      vim.keymap.set({ "n", "x", "o" }, "gl", "<Plug>(leap-forward-to)")
      vim.keymap.set({ "n", "x", "o" }, "gh", "<Plug>(leap-backward-to)")
    end,
  },
}
