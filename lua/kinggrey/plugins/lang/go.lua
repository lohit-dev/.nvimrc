-- Go language support
-- Tools for Go development in Neovim

return {
  -- Gopher.nvim - Go development plugin
  {
    "olexsmir/gopher.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "go", "gomod", "gowork" },
    build = function()
      vim.cmd [[silent! GoInstallDeps]]
    end,
    ---@module "gopher"
    ---@type gopher.Config
    opts = {

    },
  },
}
