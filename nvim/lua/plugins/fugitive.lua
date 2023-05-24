-- fugitive (git)
return {
    "tpope/vim-fugitive",
    config = function(_, opts)
        vim.api.nvim_create_user_command('Gbl', 'Git blame', {})
    end,
}
