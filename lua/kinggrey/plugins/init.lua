-- Main plugins configuration
-- This file requires all main plugins to keep init.lua clean

return {
  -- Colorscheme (load first with high priority)
  require("kinggrey.plugins.colorscheme"),

  -- Core plugins
  require("kinggrey.plugins.guess-indent"),
  require("kinggrey.plugins.gitsigns"),
  require("kinggrey.plugins.which-key"),
  require("kinggrey.plugins.telescope"),

  -- Editing plugins
  require("kinggrey.plugins.formatting"),
  require("kinggrey.plugins.treesitter"),
  require("kinggrey.plugins.autopairs"),
  require("kinggrey.plugins.indent_line"),

  -- UI plugins
  require("kinggrey.plugins.ui"),

  -- Utility plugins
  require("kinggrey.plugins.debug"),
  require("kinggrey.plugins.lint"),
  require("kinggrey.plugins.oil"), -- oil.nvim + extensions
  require("kinggrey.plugins.neo-tree"), -- Disabled, kept for future just in case
  require("kinggrey.plugins.toggleterm"),

  -- Language-specific plugins (lazy loaded by filetype)
  require("kinggrey.plugins.lang.rust"),
  require("kinggrey.plugins.lang.go"),
}

