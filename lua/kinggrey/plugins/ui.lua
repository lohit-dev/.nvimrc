return {
  -- Notifications (nvim-notify) - NvChad-like notifications
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      local notify = require("notify")
      notify.setup({
        stages = "fade_in_slide_out",
        timeout = 3000,
        max_height = function()
          return math.floor(vim.o.lines * 0.75)
        end,
        max_width = function()
          return math.floor(vim.o.columns * 0.75)
        end,
      })
      -- Replace default vim.notify with nvim-notify
      vim.notify = notify
    end,
  },
  -- Noice UI - NvChad-like command line and messages UI
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    config = function()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
          hover = {
            enabled = true,
            silent = false,
          },
          signature = {
            enabled = true,
            auto_open = {
              enabled = true,
              trigger = true,
              luasnip = true,
              throttle = 50,
            },
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = false,
        },
        cmdline = {
          enabled = true,
          view = "cmdline_popup",
          format = {
            filter = { pattern = "^:%s*!", icon = " $", ft = "sh" },
            lua = { pattern = "^:%s*lua%s+", icon = "☾ ", ft = "lua" },
            help = { pattern = "^:%s*he?l?p?%s+", icon = "󰋖 " },
          },
        },
        messages = {
          enabled = true,
          view = "notify",
          view_error = "notify",
          view_warn = "notify",
          view_history = "messages",
          view_search = "virtualtext",
        },
        notify = {
          enabled = false, -- Use nvim-notify instead
        },
        popupmenu = {
          enabled = true,
          backend = "nui",
        },
        views = {
          cmdline_popup = {
            position = {
              row = 5,
              col = "50%",
            },
            size = {
              width = 60,
              height = "auto",
            },
            border = {
              style = "rounded",
              padding = { 0, 1 },
            },
          },
        },
        routes = {
          {
            filter = {
              event = "msg_show",
              kind = "",
              find = "written",
            },
            opts = { skip = true },
          },
          {
            filter = {
              event = "msg_show",
              kind = "search_count",
            },
            opts = { skip = true },
          },
          {
            filter = {
              event = "notify",
              find = "No information available",
            },
            opts = { skip = true },
          },
        },
      })

      -- NvChad-like keybindings for noice
      vim.keymap.set("n", "<leader>snl", function()
        require("noice").cmd("last")
      end, { desc = "[S]how [N]oice [L]ast message" })

      vim.keymap.set("n", "<leader>snh", function()
        require("noice").cmd("history")
      end, { desc = "[S]how [N]oice [H]istory" })

      vim.keymap.set("n", "<leader>sna", function()
        require("noice").cmd("all")
      end, { desc = "[S]how [N]oice [A]ll messages" })

      vim.keymap.set("n", "<leader>snd", function()
        require("noice").cmd("dismiss")
      end, { desc = "[S]how [N]oice [D]ismiss" })

      vim.keymap.set({ "i", "n", "s" }, "<c-f>", function()
        if not require("noice.lsp").scroll(4) then
          return "<c-f>"
        end
      end, { silent = true, expr = true, desc = "Scroll forward" })

      vim.keymap.set({ "i", "n", "s" }, "<c-b>", function()
        if not require("noice.lsp").scroll(-4) then
          return "<c-b>"
        end
      end, { silent = true, expr = true, desc = "Scroll backward" })
    end,
  },
  -- Breadcrumbs (NvChad-style navigation)
  {
    "SmiteshP/nvim-navic",
    event = "VeryLazy",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("nvim-navic").setup({
        highlight = true,
        separator = " 󰁔 ",
        icons = {
          File = "󰈙 ",
          Module = " ",
          Namespace = "󰌗 ",
          Package = " ",
          Class = "󰌗 ",
          Method = "󰆧 ",
          Property = "󰜢 ",
          Field = "󰜢 ",
          Constructor = "󰌗 ",
          Enum = "󰒻 ",
          Interface = "󰒻 ",
          Function = "󰊕 ",
          Variable = "󰆧 ",
          Constant = "󰏿 ",
          String = "󰅳 ",
          Number = "󰎠 ",
          Boolean = "󰁨 ",
          Array = "󰅪 ",
          Object = "󰅩 ",
          Key = "󰌋 ",
          Null = "󰟢 ",
          EnumMember = "󰒻 ",
          Struct = "󰌗 ",
          Event = "󰓹 ",
          Operator = "󰆕 ",
          TypeParameter = "󰗴 ",
        },
        depth_limit = 0,
        depth_limit_indicator = "..",
      })
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },
}
