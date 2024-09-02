---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  -- available plugins can be found at https://github.com/AstroNvim/astrocommunity
  { import = "astrocommunity.recipes.heirline-nvchad-statusline" },
  { import = "astrocommunity.pack.cpp" },
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.colorscheme.catppuccin" },
}
