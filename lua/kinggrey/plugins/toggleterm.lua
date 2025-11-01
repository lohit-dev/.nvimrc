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
      autochdir = false, -- when neovim changes it current directory the terminal will change it's own when next it's opened
      shade_terminals = true,
      start_in_insert = true,
      insert_mappings = false, -- whether or not the open mapping applies in insert mode
      terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
      persist_size = true,
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

    -- Terminal vertical split
    vim.keymap.set("n", "<leader>tv", function()
      require("toggleterm").toggle(1, nil, nil, nil, "vertical")
    end, { desc = "Toggle terminal vertical" })

    -- Terminal horizontal split
    vim.keymap.set("n", "<leader>th", function()
      require("toggleterm").toggle(1, nil, nil, nil, "horizontal")
    end, { desc = "Toggle terminal horizontal" })

    -- Terminal float
    vim.keymap.set("n", "<leader>tf", function()
      require("toggleterm").toggle(1, nil, nil, nil, "float")
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

