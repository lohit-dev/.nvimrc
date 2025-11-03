-- Base46 cache loading (only if base46 is installed)
vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46_cache/"

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

-- Load base46 cache files if they exist (only when using base46/NvChad)
local base46_dir = vim.fn.stdpath("data") .. "/base46_cache"
if vim.fn.isdirectory(base46_dir) == 1 then
  local defaults_file = vim.g.base46_cache .. "defaults"
  local statusline_file = vim.g.base46_cache .. "statusline"

  if vim.fn.filereadable(defaults_file) == 1 then
    dofile(defaults_file)
  end

  if vim.fn.filereadable(statusline_file) == 1 then
    dofile(statusline_file)
  end
end
