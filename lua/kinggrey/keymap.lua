vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.o.showmode = false
-- This ensures that yank/delete operations sync with Mac clipboard
vim.o.clipboard = "unnamedplus"
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
-- Tab and indent settings
vim.o.tabstop = 2 -- Number of spaces a <Tab> in the file displays as
vim.o.shiftwidth = 2 -- Number of spaces to use for each step of (auto)indent
vim.o.expandtab = true -- Use spaces instead of tabs
vim.o.softtabstop = 2 -- Number of spaces that a <Tab> counts for while performing editing operations
vim.o.smartindent = true -- Do smart autoindenting when starting a new line
vim.o.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.o.inccommand = "split"
vim.o.cursorline = true -- Enabled but styled subtly in colorscheme
vim.o.scrolloff = 10
vim.o.confirm = true
-- Maintain block cursor in all modes (including insert mode) for stock vim feel
vim.o.guicursor = ""
-- Ensure modifiable is enabled globally to avoid permission issues
vim.o.modifiable = true

-- Create autocmd to ensure modifiable is set for file buffers
vim.api.nvim_create_autocmd("BufEnter", {
  desc = "Ensure modifiable is enabled for file buffers",
  group = vim.api.nvim_create_augroup("ensure-modifiable", { clear = true }),
  callback = function()
    if vim.bo.buftype == "" then
      vim.bo.modifiable = true
    end
  end,
})

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<cmd>write<CR>", { desc = "Save file" })
vim.keymap.set("n", "<C-c>", function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  vim.fn.setreg("+", table.concat(lines, "\n"))
end, { desc = "Copy whole file" })

vim.keymap.set("n", "[", function()
  vim.cmd("put! =repeat(nr2char(10), v:count1)")
end, { desc = "Empty line above" })

vim.keymap.set("n", "]", function()
  vim.cmd("put =repeat(nr2char(10), v:count1)")
end, { desc = "Empty line below" })

vim.keymap.set("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Close buffer" })

vim.keymap.set("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "Y", "y$", { desc = "Yank to end of line" })
vim.keymap.set("n", "<leader>wx", "<cmd>close<CR>", { desc = "Close split" })
vim.keymap.set("n", "<leader>w=", "<C-w>=", { desc = "Equalize splits" })
vim.keymap.set("n", "<M-l>", "<cmd>vertical resize +2<CR>", { desc = "Increase split width" })
vim.keymap.set("n", "<M-h>", "<cmd>vertical resize -2<CR>", { desc = "Decrease split width" })
-- Buffer deletion commands
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "[B]uffer [D]elete (current)" })
vim.keymap.set("n", "<leader>br", function()
  local current_buf = vim.api.nvim_get_current_buf()
  local all_bufs = vim.api.nvim_list_bufs()
  local buffers_to_delete = {}
  
  -- Find current buffer index in the buffer list
  local current_idx = nil
  local listed_bufs = {}
  
  for idx, buf in ipairs(all_bufs) do
    if vim.api.nvim_buf_is_valid(buf) then
      local buf_listed = vim.api.nvim_buf_get_option(buf, "buflisted")
      local buf_type = vim.api.nvim_buf_get_option(buf, "buftype")
      
      -- Only consider regular file buffers
      if buf_listed and (buf_type == "" or buf_type == "acwrite") then
        table.insert(listed_bufs, buf)
        if buf == current_buf then
          current_idx = #listed_bufs
        end
      end
    end
  end
  
  -- Delete all buffers to the right (after current) in the buffer list
  if current_idx then
    for i = current_idx + 1, #listed_bufs do
      local buf = listed_bufs[i]
      if buf ~= current_buf and vim.api.nvim_buf_is_valid(buf) then
        buffers_to_delete[buf] = true
      end
    end
  end

  -- Delete the buffers
  for buf, _ in pairs(buffers_to_delete) do
    if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
      pcall(vim.api.nvim_buf_delete, buf, { force = true })
    end
  end
  
  local count = vim.tbl_count(buffers_to_delete)
  if count > 0 then
    vim.notify("Deleted " .. count .. " buffer(s) to the right", vim.log.levels.INFO)
  else
    vim.notify("No buffers found to the right", vim.log.levels.WARN)
  end
end, { desc = "[B]uffer delete [R]ight" })

vim.keymap.set("n", "<leader>bl", function()
  local current_buf = vim.api.nvim_get_current_buf()
  local all_bufs = vim.api.nvim_list_bufs()
  local buffers_to_delete = {}
  
  -- Find current buffer index in the buffer list
  local current_idx = nil
  local listed_bufs = {}
  
  for idx, buf in ipairs(all_bufs) do
    if vim.api.nvim_buf_is_valid(buf) then
      local buf_listed = vim.api.nvim_buf_get_option(buf, "buflisted")
      local buf_type = vim.api.nvim_buf_get_option(buf, "buftype")
      
      -- Only consider regular file buffers
      if buf_listed and (buf_type == "" or buf_type == "acwrite") then
        table.insert(listed_bufs, buf)
        if buf == current_buf then
          current_idx = #listed_bufs
        end
      end
    end
  end
  
  -- Delete all buffers to the left (before current) in the buffer list
  if current_idx then
    for i = 1, current_idx - 1 do
      local buf = listed_bufs[i]
      if buf ~= current_buf and vim.api.nvim_buf_is_valid(buf) then
        buffers_to_delete[buf] = true
      end
    end
  end

  -- Delete the buffers
  for buf, _ in pairs(buffers_to_delete) do
    if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
      pcall(vim.api.nvim_buf_delete, buf, { force = true })
    end
  end
  
  local count = vim.tbl_count(buffers_to_delete)
  if count > 0 then
    vim.notify("Deleted " .. count .. " buffer(s) to the left", vim.log.levels.INFO)
  else
    vim.notify("No buffers found to the left", vim.log.levels.WARN)
  end
end, { desc = "[B]uffer delete [L]eft" })

vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "[B]uffer [N]ext" })
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "[B]uffer [P]revious" })

vim.keymap.set("n", ";", ":", { desc = "Enter command mode" })
-- vim.keymap.set("n", ":", ";", { desc = "Repeat last f/F/t/T motion" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "[D", function()
  vim.diagnostic.jump({ count = -9999, float = true })
end, { desc = "First diagnostic" })
vim.keymap.set("n", "]D", function()
  vim.diagnostic.jump({ count = 9999, float = true })
end, { desc = "Last diagnostic" })

vim.keymap.set("i", "<C-h>", "<Left>", { desc = "Cursor left" })
vim.keymap.set("i", "<C-l>", "<Right>", { desc = "Cursor right" })
vim.keymap.set("i", "<C-j>", "<Down>", { desc = "Cursor down" })
vim.keymap.set("i", "<C-k>", "<Up>", { desc = "Cursor up" })
vim.keymap.set("i", "<C-e>", "<End>", { desc = "End of line" })
vim.keymap.set("i", "<C-b>", "<Home>", { desc = "Beginning of line" })
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Git command keymaps
vim.keymap.set("n", "<leader>wa", function()
  vim.lsp.buf.add_workspace_folder()
end, { desc = "[W]orkspace [A]dd folder" })

vim.keymap.set("n", "<leader>wr", function()
  vim.lsp.buf.remove_workspace_folder()
end, { desc = "[W]orkspace [R]emove folder" })

vim.keymap.set("n", "<leader>wl", function()
  local folders = vim.lsp.buf.list_workspace_folders()
  if vim.tbl_isempty(folders) then
    vim.notify("No LSP workspace folders", vim.log.levels.INFO)
    return
  end

  vim.notify(table.concat(folders, "\n"), vim.log.levels.INFO, { title = "LSP Workspace Folders" })
end, { desc = "[W]orkspace [L]ist folders" })

vim.keymap.set("n", "<leader>wk", function()
  require("which-key").show({ global = true })
end, { desc = "[W]hich-key query lookup" })

vim.keymap.set("n", "<leader>W", function()
  require("telescope.builtin").keymaps()
end, { desc = "All keymaps" })

vim.keymap.set("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "[D]iagnostic [S]et loclist" })

vim.keymap.set("n", "<leader>fm", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "[F]ormat buffer" })

vim.keymap.set("n", "<leader>bt", function()
  vim.o.showtabline = vim.o.showtabline == 0 and 2 or 0
end, { desc = "[B]uffer [T]oggle tabline" })

-- UI toggles
local kinggrey_themes = { "dracula-soft", "catppuccin", "gruvbox-material" }
vim.g.kinggrey_theme_index = vim.g.kinggrey_theme_index
  or (function()
    local current = vim.g.colors_name
    for idx, name in ipairs(kinggrey_themes) do
      if name == current then
        return idx
      end
    end
    return 1
  end)()

local function cycle_colorscheme()
  local count = #kinggrey_themes
  local idx = (vim.g.kinggrey_theme_index or 1) % count + 1
  vim.g.kinggrey_theme_index = idx
  local theme = kinggrey_themes[idx]
  local ok, err = pcall(vim.cmd.colorscheme, theme)
  if ok then
    vim.notify("Colorscheme: " .. theme, vim.log.levels.INFO)
  else
    vim.notify("Failed to load colorscheme " .. theme .. "\n" .. err, vim.log.levels.ERROR)
  end
end

vim.keymap.set("n", "<leader>rn", function()
  vim.wo.number = true
  vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = "Toggle relative line numbers" })

vim.keymap.set("n", "<leader>n", function()
  vim.wo.number = not vim.wo.number
  if not vim.wo.number then
    vim.wo.relativenumber = false
  end
end, { desc = "Toggle line numbers" })

vim.keymap.set("n", "<leader>uw", function()
  vim.wo.wrap = not vim.wo.wrap
end, { desc = "Toggle word wrap" })

vim.keymap.set("n", "<leader>ul", function()
  vim.o.list = not vim.o.list
end, { desc = "Toggle list characters" })

vim.keymap.set("n", "<leader>ut", cycle_colorscheme, { desc = "Cycle colorscheme" })

local function leet_exec(cmd)
  vim.cmd("Leet " .. cmd)
end

local function leet_map(lhs, cmd, desc)
  vim.keymap.set("n", lhs, function()
    leet_exec(cmd)
  end, { desc = desc })
end

leet_map("<leader>lm", "menu", "[L]eetCode [M]enu")
leet_map("<leader>lx", "exit", "[L]eetCode e[X]it")
leet_map("<leader>lc", "console", "[L]eetCode [C]onsole panel")
leet_map("<leader>lr", "run", "[L]eetCode [R]un question")
leet_map("<leader>lt", "test", "[L]eetCode [T]est question")
leet_map("<leader>ls", "submit", "[L]eetCode [S]ubmit answer")
leet_map("<leader>ll", "menu", "[L]eetCode home")
leet_map("<leader>lH", "desc stats", "[L]eetCode s[Ta]ts toggle")
leet_map("<leader>lL", "lang", "[L]eetCode change [L]anguage")
leet_map("<leader>ld", "daily", "[L]eetCode [D]aily problem")
leet_map("<leader>lo", "open", "[L]eetCode [O]pen in browser")
vim.keymap.set("n", "<leader>li", function()
  local ok, image = pcall(require, "image")
  if ok then
    image.clear()
    vim.notify("Images cleared", vim.log.levels.INFO)
  else
    vim.notify("image.nvim not loaded", vim.log.levels.WARN)
  end
end, { desc = "Clear ghost [I]mages" })

-- Code Actions
vim.keymap.set({ "n", "v" }, "<leader>ca", function()
  vim.lsp.buf.code_action()
end, { desc = "[C]ode [A]ctions" })

vim.keymap.set("n", "<leader>cf", function()
  vim.lsp.buf.format({ async = false })
end, { desc = "[C]ode [F]ormat buffer" })

vim.keymap.set("n", "<leader>cr", function()
  vim.lsp.buf.rename()
end, { desc = "[C]ode [R]ename symbol" })

vim.keymap.set("n", "<leader>cd", function()
  vim.diagnostic.open_float(nil, { focus = false })
end, { desc = "[C]ode show line [D]iagnostics" })

-- Buffer Navigation
vim.keymap.set("n", "<S-l>", function()
  vim.cmd("bnext")
end, { desc = "Next buffer" })
