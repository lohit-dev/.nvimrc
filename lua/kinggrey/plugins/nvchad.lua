return {
  { "nvim-lua/plenary.nvim" },
  { "nvim-tree/nvim-web-devicons", lazy = true },

  {
    "nvchad/base46",
    lazy = false, -- Load early to generate cache files
    priority = 2000, -- Load before colorscheme
    build = function()
      require("base46").load_all_highlights()
    end,
    config = function()
    end,
  },

  {
    "nvchad/ui",
    init = function()
      vim.g.tabufline_enabled = false
      vim.g.nvdash_enabled = false
      vim.g.statusline_enabled = true
    end,
    config = function()
      require("nvchad")
    end,
  },
}
