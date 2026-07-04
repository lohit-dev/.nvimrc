-- Colorscheme plugins.
--
-- None of these call `vim.cmd.colorscheme(...)` themselves anymore -- that
-- used to be duplicated per-theme (and only dracula's was actually live,
-- which is why nothing you picked ever stuck). Theme selection, persistence,
-- and the shared statusline/highlight logic all now live in
-- lua/kinggrey/theme.lua, applied once via M.load() after lazy.nvim finishes
-- loading (see init.lua).
--
-- To switch themes: `:Theme <name>` or `:colorscheme <name>` (tab-complete
-- works), or `:Telescope colorscheme` for a live preview picker. Whatever you
-- land on gets remembered automatically for next launch.

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        transparent_background = true,
        integrations = {
          lualine = {},
          treesitter = true,
          telescope = true,
          cmp = true,
        },
      })
    end,
  },

  {
    "Mofiqul/dracula.nvim",
    priority = 1000,
    config = function()
      require("dracula").setup({
        theme = "dracula-soft",
        show_end_of_buffer = true,
        transparent_bg = true,
        lualine_bg_color = "#44475a",
        italic_comment = true,
        overrides = function(c)
          return {
            CursorLine = { bg = "NONE" },
            CursorLineNr = { fg = c.purple, bold = true },
            CursorLineFold = { bg = "NONE" },
          }
        end,
      })
    end,
  },

  {
    "sainnhe/gruvbox-material",
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_enable_italic = true
    end,
  },

  -- Tokyo Night -- same "dark, vibrant, high-contrast" lane as dracula
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = {
      style = "storm", -- storm, moon, night, day
      transparent = true,
      styles = { comments = { italic = true } },
    },
  },

  -- Kanagawa -- muted/warm dark theme, good contrast with the above two
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    opts = {
      theme = "wave", -- wave, dragon, lotus
      transparent = true,
    },
  },

  -- Rose Pine -- softer, low-contrast dark theme
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    opts = {
      variant = "main", -- main, moon, dawn
      dark_variant = "main",
    },
  },

  -- Nightfox -- another highly configurable dark family, ships multiple
  -- variants (nightfox, duskfox, nordfox, terafox, carbonfox) as one plugin
  {
    "EdenEast/nightfox.nvim",
    priority = 1000,
    opts = {},
  },

  -- Everforest -- warm, low-contrast, easy on the eyes for long sessions
  {
    "sainnhe/everforest",
    priority = 1000,
    config = function()
      vim.g.everforest_background = "medium" -- soft, medium, hard
      vim.g.everforest_enable_italic = true
    end,
  },
}
