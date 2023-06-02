return {
    "junegunn/fzf.vim",
    keys = {
      { "<leader>/", "<cmd>Rg!<cr>", desc = "Ripgrep" },
      { "<leader><Space>", "<cmd>Files<cr>", desc = "Files" },
      { "<leader>b", "<cmd>Buffers<cr>", desc = "Buffers" },
      { "<leader>t", "<cmd>Tags<cr>", desc = "Tags" },
    },
    init = function()
        vim.g.fzf_layout = { down = "~100%" }
        vim.g.fzf_preview_window = {"right:50%", "ctrl-/"}
        vim.g.fzf_history_dir = "~/.local/share/fzf-history"
        vim.env.FZF_DEFAULT_COMMAND = "rg --files --hidden"
        vim.env.RIPGREP_CONFIG_PATH = vim.env.HOME .. "/.config/ripgreprc"
    end,
    dependencies = {
        "junegunn/fzf",
        run = function()
            vim.fn['fzf#install']()
        end,
    },
}
