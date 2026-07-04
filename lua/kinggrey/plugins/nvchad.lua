return {
  { "nvim-lua/plenary.nvim" },
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- nvchad/base46 + nvchad/ui removed: they were only providing
  -- tabufline/nvdash/statusline, all of which are either disabled here
  -- or already replaced by lua/kinggrey/theme.lua. Their only remaining
  -- live effect was base46's cached "onedark" highlights silently
  -- overriding whatever real colorscheme was picked via :Theme /
  -- :colorscheme / <leader>ut on every startup.
}

