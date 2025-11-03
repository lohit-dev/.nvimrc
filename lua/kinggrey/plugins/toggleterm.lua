-- toggleterm.nvim
-- A neovim plugin to persist and toggle multiple terminals during an editing session
-- https://github.com/akinsho/toggleterm.nvim

return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      size = 20,
      open_mapping = nil, -- We'll use custom mappings instead
      hide_numbers = true, -- hide the number column in toggleterm buffers
      shade_filetypes = {},
      autochdir = true, -- when neovim changes it current directory the terminal will change it's own when next it's opened
      shade_terminals = true,
      start_in_insert = true,
      insert_mappings = false, -- whether or not the open mapping applies in insert mode
      terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
      persist_size = false,
      persist_mode = true, -- if set to true (default) the previous terminal mode will be remembered
      direction = "horizontal", -- default direction
      close_on_exit = true, -- close the terminal window when the process exits
      shell = vim.o.shell,
      auto_scroll = true, -- automatically scroll to the bottom on terminal output
      float_opts = {
        border = "curved",
        winblend = 3,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    })

    -- Custom keymaps for terminal
    local Terminal = require("toggleterm.terminal").Terminal

    -- Create separate terminal instances for different directions
    -- Use unique count IDs to separate them and set sizes directly
    local vertical_term = Terminal:new({
      direction = "vertical",
      count = 2,
      on_open = function(term)
        -- Resize immediately on open - use schedule to ensure window is ready
        vim.schedule(function()
          if term and term.bufnr then
            local wins = vim.fn.win_findbuf(term.bufnr)
            if #wins > 0 and vim.api.nvim_win_is_valid(wins[1]) then
              local cols = math.floor(vim.o.columns * 0.5)
              vim.api.nvim_win_set_width(wins[1], cols)
            end
          end
        end)
      end,
    })

    local horizontal_term = Terminal:new({
      direction = "horizontal",
      count = 3,
      size = 15, -- 15 lines
      on_open = function(term)
        -- Resize immediately on open - use schedule to ensure window is ready
        vim.schedule(function()
          if term and term.bufnr then
            local wins = vim.fn.win_findbuf(term.bufnr)
            if #wins > 0 and vim.api.nvim_win_is_valid(wins[1]) then
              vim.api.nvim_win_set_height(wins[1], 15)
            end
          end
        end)
      end,
    })

    local float_term = Terminal:new({
      direction = "float",
      count = 4,
    })

    -- Terminal vertical split
    vim.keymap.set("n", "<leader>tv", function()
      vertical_term:toggle()
    end, { desc = "Toggle terminal vertical" })

    -- Terminal horizontal split
    vim.keymap.set("n", "<leader>th", function()
      horizontal_term:toggle()
    end, { desc = "Toggle terminal horizontal" })

    -- Terminal float
    vim.keymap.set("n", "<leader>tf", function()
      float_term:toggle()
    end, { desc = "Toggle terminal float" })

    -- Terminal window mappings for easier navigation
    local function set_terminal_keymaps()
      local opts = { buffer = 0 }
      vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
      vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
      vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
      vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
    end

    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "term://*toggleterm#*",
      callback = set_terminal_keymaps,
    })
  end,
}
