return {
  -- Catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    enabled = false,
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

  -- Dracula (original)
  {
    "Mofiqul/dracula.nvim",
    priority = 1000,
    enabled = true,
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

      vim.cmd.colorscheme("dracula-soft")

      -- Make statusline completely transparent (no background bar)
      vim.api.nvim_set_hl(0, "StatusLine", {
        bg = "NONE",
        fg = vim.api.nvim_get_hl(0, { name = "Normal" }).fg or "#f8f8f2",
      })
      vim.api.nvim_set_hl(0, "StatusLineNC", {
        bg = "NONE",
        fg = vim.api.nvim_get_hl(0, { name = "Normal" }).fg or "#f8f8f2",
      })

      -- Statusline helper function
      _G.kinggrey = _G.kinggrey or {}
      _G.kinggrey.statusline = {
        get_mode = function()
          local mode = vim.api.nvim_get_mode().mode
          local mode_map = {
            n = "NORMAL",
            i = "INSERT",
            v = "VISUAL",
            V = "VISUAL LINE",
            ["\22"] = "VISUAL BLOCK",
            c = "COMMAND",
            t = "TERMINAL",
            R = "REPLACE",
            s = "SELECT",
            S = "SELECT LINE",
          }
          return mode_map[mode] or mode:upper()
        end,
      }
      package.loaded["kinggrey.statusline"] = _G.kinggrey.statusline

      -- Minimal statusline: left corner | (invisible middle) | right corner
      -- Only shows text at corners, no background bar
      vim.opt.statusline =
        "%{toupper(v:lua.require('kinggrey.statusline').get_mode())} %f%=%l:%c %p%%"
    end,
  },
  -- Gruvbox Material
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_enable_italic = true
      -- vim.cmd.colorscheme("gruvbox-material")

      -- Make statusline completely transparent (no background bar)
      vim.api.nvim_set_hl(0, "StatusLine", {
        bg = "NONE",
        fg = vim.api.nvim_get_hl(0, { name = "Normal" }).fg or "#ebdbb2",
      })
      vim.api.nvim_set_hl(0, "StatusLineNC", {
        bg = "NONE",
        fg = vim.api.nvim_get_hl(0, { name = "Normal" }).fg or "#ebdbb2",
      })

      -- Statusline helper function
      _G.kinggrey = _G.kinggrey or {}
      _G.kinggrey.statusline = {
        get_mode = function()
          local mode = vim.api.nvim_get_mode().mode
          local mode_map = {
            n = "NORMAL",
            i = "INSERT",
            v = "VISUAL",
            V = "VISUAL LINE",
            ["\22"] = "VISUAL BLOCK",
            c = "COMMAND",
            t = "TERMINAL",
            R = "REPLACE",
            s = "SELECT",
            S = "SELECT LINE",
          }
          return mode_map[mode] or mode:upper()
        end,
      }
      package.loaded["kinggrey.statusline"] = _G.kinggrey.statusline

      -- Minimal statusline: left corner | (invisible middle) | right corner
      -- Only shows text at corners, no background bar
      vim.opt.statusline =
        "%{toupper(v:lua.require('kinggrey.statusline').get_mode())} %f%=%l:%c %p%%"
    end,
  },
}
