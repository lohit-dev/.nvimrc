-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  "nvim-neo-tree/neo-tree.nvim",
  enabled = false, -- Disabled, using oil.nvim instead
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- optional but recommended for icons
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree", -- only load when Neotree command is used
  keys = {
    {
      "<leader>e",
      function()
        require("neo-tree.command").execute({
          source = "filesystem",
          position = "right",
          toggle = true,
          reveal = true,
        })
      end,
      desc = "Toggle Neo-tree (right side)",
      silent = true,
    },
  },
  opts = {
    filesystem = {
      follow_current_file = { enabled = true },
      group_empty_dirs = true,
      hijack_netrw_behavior = "open_default",
      window = {
        width = 30, -- Set sidebar width
        mappings = {}, -- don't mess with mappings inside the tree
      },
    },
    default_component_configs = {
      indent = { padding = 1 },
      icon = { folder_closed = "", folder_open = "", folder_empty = "ﰊ" },
    },
  },
}
