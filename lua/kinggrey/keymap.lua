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
vim.keymap.set("n", "<leader>w", "<cmd>write<CR>", { desc = "[W]rite/Save file" })
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
vim.keymap.set("n", ";", ":", { desc = "Enter command mode" })
-- vim.keymap.set("n", ":", ";", { desc = "Repeat last f/F/t/T motion" })
vim.keymap.set(
  "n",
  "<leader>x",
  vim.diagnostic.setloclist,
  { desc = "Open diagnostic [Q]uickfix list" }
)
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Git command keymaps
vim.keymap.set("n", "<leader>ga", function()
  vim.cmd("!git add .")
end, { desc = "[G]it [a]dd all files" })
vim.keymap.set("n", "<leader>gA", function()
  vim.ui.input({ prompt = "Git add: " }, function(input)
    if input then
      vim.cmd("!git add " .. input)
    end
  end)
end, { desc = "[G]it [A]dd specific files" })

vim.keymap.set("n", "<leader>gc", function()
  vim.ui.input({ prompt = "Commit message: " }, function(input)
    if input then
      vim.cmd("!git commit -m '" .. input .. "'")
    end
  end)
end, { desc = "[G]it [c]ommit" })

vim.keymap.set("n", "<leader>gp", function()
  vim.cmd("!git push")
end, { desc = "[G]it [p]ush" })

vim.keymap.set("n", "<leader>gs", function()
  vim.cmd("!git status")
end, { desc = "[G]it [s]tatus" })

vim.keymap.set("n", "<leader>gS", function()
  vim.cmd("!git stash")
end, { desc = "[G]it [S]tash" })

vim.keymap.set("n", "<leader>gr", function()
  vim.cmd("!git reflog")
end, { desc = "[G]it [r]eflog" })

vim.keymap.set("n", "<leader>gR", function()
  vim.ui.input({ prompt = "Git rebase (branch or options): " }, function(input)
    if input then
      vim.cmd("!git rebase " .. input)
    else
      vim.cmd("!git rebase")
    end
  end)
end, { desc = "[G]it [R]ebase" })

-- Package Management (Lazy.nvim)
vim.keymap.set("n", "<leader>pl", function()
  require("lazy").show()
end, { desc = "[P]lugins [L]azy (show)" })

vim.keymap.set("n", "<leader>pi", function()
  require("lazy").install()
end, { desc = "[P]lugins [I]nstall" })

vim.keymap.set("n", "<leader>pS", function()
  require("lazy").sync()
end, { desc = "[P]lugins [S]ync" })

vim.keymap.set("n", "<leader>ps", function()
  require("lazy").status()
end, { desc = "[P]lugins [S]tatus" })

vim.keymap.set("n", "<leader>pu", function()
  require("lazy").check()
end, { desc = "[P]lugins Check for [U]pdates" })

vim.keymap.set("n", "<leader>pU", function()
  require("lazy").update()
end, { desc = "[P]lugins [U]pdate" })

-- Mason Package Manager
vim.keymap.set("n", "<leader>pm", function()
  vim.cmd("Mason")
end, { desc = "[P]ackages [M]ason" })

vim.keymap.set("n", "<leader>pM", function()
  vim.cmd("MasonToolsUpdate")
end, { desc = "[P]ackages [M]ason Update" })

-- Code Actions
vim.keymap.set({ "n", "v" }, "<leader>ca", function()
  vim.lsp.buf.code_action()
end, { desc = "[C]ode [A]ctions" })

-- Buffer Navigation
vim.keymap.set("n", "<S-l>", function()
  vim.cmd("bnext")
end, { desc = "Next buffer" })
