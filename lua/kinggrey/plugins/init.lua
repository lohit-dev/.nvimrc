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
  require("kinggrey.plugins.autotag"), -- Auto-close HTML/JSX tags

  -- UI plugins
  require("kinggrey.plugins.ui"),
  require("kinggrey.plugins.profile"), -- Profile/dashboard homepage

  -- Utility plugins
  require("kinggrey.plugins.debug"),
  require("kinggrey.plugins.lint"),
  require("kinggrey.plugins.oil"), -- oil.nvim + extensions
  require("kinggrey.plugins.neo-tree"), -- Disabled, kept for future just in case
  require("kinggrey.plugins.toggleterm"),
  require("kinggrey.plugins.web-tools"), -- Web dev tools (browser-sync, hurl, npm/yarn/npx)

  -- Language-specific plugins (lazy loaded by filetype)
  require("kinggrey.plugins.lang.rust"),
  require("kinggrey.plugins.lang.go"),
}

