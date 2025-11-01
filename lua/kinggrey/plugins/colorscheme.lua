-- dracula.nvim
-- Dracula colorscheme for Neovim
-- https://github.com/Mofiqul/dracula.nvim

return {
  "Mofiqul/dracula.nvim",
  priority = 1000, -- Make sure this loads before other plugins
  -- enabled = false,
  config = function()
    local dracula = require("dracula")
    local colors = dracula.colors()

    dracula.setup({
      theme = "dracula-soft",
      -- show the '~' characters after the end of buffers
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

    -- Load the colorscheme
    vim.cmd("colorscheme dracula-soft")
  end,
}
