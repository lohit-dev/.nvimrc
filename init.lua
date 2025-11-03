-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out =
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end

local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- Load keymap configuration before lazy setup
require("kinggrey.keymap")

local lsp_plugins = require("kinggrey.plugins.lsp")
local plugins = require("kinggrey.plugins")

-- Combine all plugins into a single table
local all_plugins = {}
for _, plugin in ipairs(plugins) do
  table.insert(all_plugins, plugin)
end
for _, plugin in ipairs(lsp_plugins) do
  table.insert(all_plugins, plugin)
end

require("lazy").setup(all_plugins, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = "⌘",
      init = "⚙",
      lazy = "💤 ",
    },
  },
})
