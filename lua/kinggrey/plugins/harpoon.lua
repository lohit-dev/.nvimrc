return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    local function list()
      return harpoon:list()
    end

    vim.keymap.set("n", "<leader>mA", function()
      list():add()
    end, { desc = "Harpoon add file" })

    vim.keymap.set("n", "<leader>mm", function()
      harpoon.ui:toggle_quick_menu(list())
    end, { desc = "Harpoon menu" })

    vim.keymap.set("n", "<leader>1", function()
      list():select(1)
    end, { desc = "Harpoon file 1" })

    vim.keymap.set("n", "<leader>2", function()
      list():select(2)
    end, { desc = "Harpoon file 2" })

    vim.keymap.set("n", "<leader>3", function()
      list():select(3)
    end, { desc = "Harpoon file 3" })

    vim.keymap.set("n", "<leader>4", function()
      list():select(4)
    end, { desc = "Harpoon file 4" })

    vim.keymap.set("n", "<leader>mn", function()
      list():next()
    end, { desc = "Harpoon next" })

    vim.keymap.set("n", "<leader>mp", function()
      list():prev()
    end, { desc = "Harpoon previous" })
  end,
}
