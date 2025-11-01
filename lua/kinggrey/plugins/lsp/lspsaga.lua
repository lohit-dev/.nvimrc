-- lspsaga.nvim
-- Enhanced LSP UI with code actions, diagnostics, and more
-- https://github.com/nvimdev/lspsaga.nvim

return {
  "nvimdev/lspsaga.nvim",
  config = function()
    require("lspsaga").setup({})
  end,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
}

