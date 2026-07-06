local M = {}

local function to_hex(color)
  if type(color) ~= "number" then
    return nil
  end
  return string.format("#%06x", color)
end

local function hl(name)
  local ok, value = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
  if not ok then
    return {}
  end
  return value
end

local function pick(specs, key, fallback)
  for _, name in ipairs(specs) do
    local value = to_hex(hl(name)[key])
    if value then
      return value
    end
  end
  return fallback
end

local function palette()
  return {
    blue = pick({ "Function", "Special", "Directory" }, "fg", "#80a0ff"),
    cyan = pick({ "String", "Conditional", "DiagnosticInfo" }, "fg", "#79dac8"),
    black = pick({ "Normal", "NormalNC" }, "bg", "#080808"),
    white = pick({ "StatusLine", "Normal" }, "fg", "#c6c6c6"),
    red = pick({ "DiagnosticError", "ErrorMsg" }, "fg", "#ff5189"),
    violet = pick({ "Keyword", "Type", "Statement" }, "fg", "#d183e8"),
    grey = pick({ "StatusLine", "StatusLineNC", "Folded" }, "bg", "#303030"),
  }
end

local function bubbles_theme()
  local colors = palette()

  return {
    normal = {
      a = { fg = colors.black, bg = colors.violet },
      b = { fg = colors.white, bg = colors.grey },
      c = { fg = colors.white, bg = colors.black },
    },
    insert = {
      a = { fg = colors.black, bg = colors.blue },
      b = { fg = colors.white, bg = colors.grey },
    },
    visual = {
      a = { fg = colors.black, bg = colors.cyan },
      b = { fg = colors.white, bg = colors.grey },
    },
    replace = {
      a = { fg = colors.black, bg = colors.red },
      b = { fg = colors.white, bg = colors.grey },
    },
    command = {
      a = { fg = colors.black, bg = colors.cyan },
      b = { fg = colors.white, bg = colors.grey },
    },
    inactive = {
      a = { fg = colors.white, bg = colors.black },
      b = { fg = colors.white, bg = colors.black },
      c = { fg = colors.white, bg = colors.black },
    },
  }
end

-- local function config()
--   -- local in_tmux = vim.env.TMUX and vim.env.TMUX ~= ""
--   local active = {
--     lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
--     lualine_b = { "filename", "branch" },
--     lualine_c = { "%=" },
--     lualine_x = {},
--     lualine_y = { "filetype", "progress" },
--     lualine_z = { { "location", separator = { right = "" }, left_padding = 2 } },
--   }
--
--   local inactive = {
--     lualine_a = { "filename" },
--     lualine_b = {},
--     lualine_c = {},
--     lualine_x = {},
--     lualine_y = {},
--     lualine_z = { "location" },
--   }
--
--   return {
--     options = {
--       theme = bubbles_theme(),
--       component_separators = "",
--       section_separators = { left = "", right = "" },
--     },
--     sections = {},
--     inactive_sections = {},
--     -- winbar = in_tmux and {} or active,
--     -- inactive_winbar = in_tmux and {} or inactive,
--     winbar = active,
--     inactive_winbar = inactive,
--     tabline = {},
--     extensions = {},
--   }
-- end
--
-- function M.refresh()
--   local ok, lualine = pcall(require, "lualine")
--   if not ok then
--     return
--   end
--   vim.opt.laststatus = 0
--   vim.opt.statusline = " "
--   -- vim.opt.winbar = nil
--   lualine.setup(config())
--   lualine.refresh()
-- end
--

function M.setup()
  M.refresh()
end

local function config()
  local active = {
    lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
    lualine_b = { "filename", "branch" },
    lualine_c = { "%=" },
    lualine_x = {},
    lualine_y = { "filetype", "progress" },
    lualine_z = { { "location", separator = { right = "" }, left_padding = 2 } },
  }

  local inactive = {
    lualine_a = { "filename" },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { "location" },
  }

  return {
    options = {
      theme = bubbles_theme(),
      component_separators = "",
      section_separators = { left = "", right = "" },
      globalstatus = true,
    },
    sections = active,
    inactive_sections = inactive,
    winbar = {},
    inactive_winbar = {},
    tabline = {},
    extensions = {},
  }
end

function M.refresh()
  local ok, lualine = pcall(require, "lualine")
  if not ok then
    return
  end

  vim.opt.laststatus = 3

  lualine.setup(config())
  lualine.refresh()
end

return M
