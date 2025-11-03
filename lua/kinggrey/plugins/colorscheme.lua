return {
  -- Catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    enabled = true,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        transparent_background = false,
        integrations = {
          lualine = true,
          treesitter = true,
          telescope = true,
          cmp = true,
        },
      })

      -- vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- Dracula
  {
    "Mofiqul/dracula.nvim",
    priority = 1000,
    enabled = false,
    config = function()
      local dracula = require("dracula")
      local colors = dracula.colors()

      dracula.setup({
        theme = "dracula-soft",
        show_end_of_buffer = true,
        transparent_bg = false,
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

      -- vim.cmd.colorscheme("dracula-soft")
    end,
  },
}
