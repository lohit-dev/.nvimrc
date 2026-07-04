-- Theme persistence + shared statusline/highlight logic.
--
-- Problem this solves: previously, each colorscheme plugin (catppuccin,
-- dracula, gruvbox-material) had its own copy-pasted statusline setup, and
-- only dracula's `config` function actually called `vim.cmd.colorscheme(...)`.
-- That meant dracula-soft got force-applied on every startup no matter what
-- you picked last session -- there was no persistence at all.
-- This module:
--   1. Saves whatever colorscheme is active to a small file on disk whenever
--      it changes (via the `ColorScheme` autocmd, which fires no matter how
--      the change happened -- `:colorscheme x`, a picker, this module, etc).
--   2. Reads that file on startup and re-applies it, falling back to a
--      sensible default if nothing's saved yet or the saved theme isn't
--      installed.
--   3. Applies the statusline + a couple of highlight overrides once, in a
--      theme-agnostic way, instead of duplicating it per-theme.

local M = {}

local state_file = vim.fn.stdpath("data") .. "/kinggrey_theme.txt"
local default_theme = "dracula-soft"

--- Write the given colorscheme name to disk.
---@param name string
function M.save(name)
  local file = io.open(state_file, "w")
  if not file then
    return
  end
  file:write(name)
  file:close()
end

--- Read the persisted colorscheme name, or nil if none saved yet.
---@return string|nil
function M.read()
  local file = io.open(state_file, "r")
  if not file then
    return nil
  end
  local name = file:read("*a")
  file:close()
  name = name and vim.trim(name) or nil
  if name == "" then
    return nil
  end
  return name
end

--- Apply the persisted theme (or the default), meant to be called once after
--- lazy.nvim has finished loading plugins.
function M.load()
  local name = M.read() or default_theme
  local ok = pcall(vim.cmd.colorscheme, name)
  if not ok then
    vim.notify(
      ("kinggrey.theme: couldn't apply saved colorscheme '%s', falling back to '%s'"):format(
        name,
        default_theme
      ),
      vim.log.levels.WARN
    )
    pcall(vim.cmd.colorscheme, default_theme)
  end
end

--- Theme-agnostic statusline helper: shown mode name in the corner.
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

-- Minimal statusline: left corner | (invisible middle) | right corner.
-- Set once, works for any theme since it doesn't depend on a specific
-- theme's colors.
vim.opt.statusline = "%{toupper(v:lua.require('kinggrey.statusline').get_mode())} %f%=%l:%c %p%%"

--- Reapply the transparent-statusline highlight override. Runs on every
--- ColorScheme change so it works no matter which theme is active, instead
--- of being copy-pasted inside each theme's own setup function.
local function apply_statusline_highlights()
  local normal_fg = vim.api.nvim_get_hl(0, { name = "Normal" }).fg
  vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE", fg = normal_fg })
  vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE", fg = normal_fg })
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("KingGreyTheme", { clear = true }),
  callback = function()
    -- Persist whatever colorscheme just became active.
    M.save(vim.g.colors_name or "")
    -- Re-apply the theme-agnostic statusline highlight tweak.
    apply_statusline_highlights()
  end,
})

--- Convenience command: :Theme <name> switches AND persists (persistence
-- happens automatically via the autocmd above, this is just a shorter
-- alias than typing :colorscheme).
vim.api.nvim_create_user_command("Theme", function(opts)
  vim.cmd.colorscheme(opts.args)
end, {
  nargs = 1,
  complete = "color",
})

--- <leader>ut: Telescope colorscheme picker with live preview. Persistence
-- is automatic -- whatever you land on (by pressing <CR>) fires the
-- ColorScheme autocmd above, which saves it. Pressing <Esc>/<C-c> reverts to
-- whatever was active before you opened the picker, and that revert fires
-- the same autocmd, so it correctly re-saves the original instead of
-- leaving a half-picked theme persisted.
vim.keymap.set("n", "<leader>ut", function()
  require("telescope.builtin").colorscheme({ enable_preview = true })
end, { desc = "[U]I: pick [T]heme (Telescope, live preview)" })

return M
