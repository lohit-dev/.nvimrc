-- blink.cmp
-- Autocompletion engine
-- https://github.com/saghen/blink.cmp

local function has_words_before()
  local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- Fix: blink.cmp highlights the active signature parameter with a reverse-video
-- style highlight. When the parameter is empty (e.g. right after typing a comma),
-- that zero-width highlight renders as a solid block that looks like a fake
-- cursor sitting inside the floating window. It isn't your real cursor -- the
-- window is non-focusable -- it's just this highlight group. Swap it to an
-- underline so it reads as "active param" instead of "cursor moved".
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelpActiveParameter", {
      underline = true,
      bold = true,
      fg = "NONE",
      bg = "NONE",
    })
  end,
})
vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelpActiveParameter", {
  underline = true,
  bold = true,
  fg = "NONE",
  bg = "NONE",
})

return {
  "saghen/blink.cmp",
  version = "^1",
  event = "VimEnter",
  dependencies = {
    -- Snippet Engine
    {
      "L3MON4D3/LuaSnip",
      version = "2.*",
      build = (function()
        if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
          return
        end
        return "make install_jsregexp"
      end)(),
      dependencies = {
        {
          "rafamadriz/friendly-snippets",
          config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
          end,
        },
      },
    },
    { "folke/lazydev.nvim" },
    -- Git completion
    {
      "Kaiser-Yang/blink-cmp-git",
      dependencies = { "nvim-lua/plenary.nvim" },
      lazy = true,
    },
    -- Conventional commits
    { "disrupted/blink-cmp-conventional-commits", lazy = true },
    -- Colorful menu
    { "xzbdmw/colorful-menu.nvim", lazy = true },
    -- Pretty hover parser for better documentation formatting
    {
      "Fildo7525/pretty_hover",
      lazy = true,
      config = function()
        require("pretty_hover").setup({})
      end,
    },
  },
  --- @type blink.cmp.Config
  opts = {
    sources = {
      -- Add git and conventional commits to defaults
      default = { "lsp", "path", "snippets", "lazydev", "conventional_commits", "git" },
      providers = {
        lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
        git = {
          module = "blink-cmp-git",
          name = "Git",
          -- Only enable in gitcommit, markdown, or octo filetypes
          enabled = function()
            return vim.tbl_contains({ "octo", "gitcommit", "markdown" }, vim.bo.filetype)
          end,
          --- @module "blink-cmp-git"
          --- @type blink-cmp-git.Options
          opts = {
            commit = {
              -- You may want to customize when it should be enabled
              -- The default will enable this when `git` is found and `cwd` is in a git repository
            },
            git_centers = {
              github = {
                -- issue = { get_token = function() return "" end },
                -- pull_request = { get_token = function() return "" end },
                -- mention = { get_token = function() return "" end },
              },
              gitlab = {
                -- issue = { get_token = function() return "" end },
                -- pull_request = { get_token = function() return "" end },
                -- mention = { get_token = function() return "" end },
              },
            },
          },
        },
        conventional_commits = {
          name = "Conventional Commits",
          module = "blink-cmp-conventional-commits",
          enabled = function()
            return vim.bo.filetype == "gitcommit"
          end,
          --- @module "blink-cmp-conventional-commits"
          --- @type blink-cmp-conventional-commits.Options
          opts = {},
        },
        -- Path completion from cwd instead of current buffer's directory
        path = {
          opts = {
            get_cwd = function(_)
              return vim.fn.getcwd()
            end,
          },
        },
      },
    },
    cmdline = {
      keymap = {
        -- Recommended, as the default keymap will only show and select the next item
        ["<Tab>"] = {
          "show_and_insert",
          "select_next",
        },
        ["<CR>"] = {
          function(cmp)
            if cmp.is_ghost_text_visible() and not cmp.is_menu_visible() then
              return cmp.accept()
            end
          end,
          "accept_and_enter",
          "fallback",
        },
        ["<Left>"] = {},
        ["<Right>"] = {},
      },
      completion = {
        menu = {
          auto_show = true,
          draw = {
            columns = {
              { "kind_icon" },
              { "label", gap = 1 },
            },
          },
        },
        list = {
          selection = {
            preselect = true,
            auto_insert = true,
          },
        },
      },
    },
    signature = {
      enabled = true,
      window = {
        border = "rounded",
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
        treesitter_highlighting = true,
        show_documentation = false,
        max_height = 8,
        max_width = 100,
      },
    },
    -- APIs: https://github.com/Saghen/blink.cmp/blob/main/lua/blink/cmp/init.lua
    keymap = {
      ["<Tab>"] = {
        function(cmp)
          return cmp.select_next({ auto_insert = true })
        end,
        "snippet_forward",
        function(cmp)
          if has_words_before() or vim.api.nvim_get_mode().mode == "c" then
            return cmp.show()
          end
        end,
        "fallback",
      },
      ["<S-Tab>"] = {
        function(cmp)
          return cmp.select_prev({ auto_insert = true })
        end,
        "snippet_backward",
        function(cmp)
          if vim.api.nvim_get_mode().mode == "c" then
            return cmp.show()
          end
        end,
        "fallback",
      },
      ["<CR>"] = {
        function(cmp)
          -- If menu is visible, accept the selection
          if cmp.is_menu_visible() then
            return cmp.accept()
          end
        end,
        "accept",
        "fallback",
      },
    },
    appearance = {
      nerd_font_variant = "mono",
    },
    completion = {
      trigger = {
        show_on_backspace_in_keyword = true,
        show_on_insert = true,
      },
      ghost_text = {
        enabled = true,
        show_with_menu = true,
      },
      list = {
        selection = {
          preselect = true, -- Preselect first item
          auto_insert = false, -- Don't auto-insert, wait for Enter to confirm
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
        draw = function(opts)
          if opts.item and opts.item.documentation then
            -- Try to use pretty_hover parser if available
            local parsed_ok, hover_parser = pcall(function()
              return require("pretty_hover.parser")
            end)
            if parsed_ok and hover_parser then
              local docs = type(opts.item.documentation) == "string" and opts.item.documentation
                or opts.item.documentation.value
              local parse_ok, result = pcall(function()
                return hover_parser.parse(docs)
              end)
              if parse_ok and result then
                docs = result:string()
              end
            end
          end
          opts.default_implementation(opts)
        end,
      },
      menu = {
        draw = {
          columns = {
            { "kind_icon" },
            { "label", gap = 1 },
            { "source_name" },
          },
          components = {
            label = {
              text = function(ctx)
                local highlights_info = require("colorful-menu").blink_highlights(ctx)
                if highlights_info ~= nil then
                  return highlights_info.label
                else
                  return ctx.label
                end
              end,
              highlight = function(ctx)
                local highlights = {}
                local highlights_info = require("colorful-menu").blink_highlights(ctx)
                if highlights_info ~= nil then
                  highlights = highlights_info.highlights
                end
                for _, idx in ipairs(ctx.label_matched_indices) do
                  table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
                end
                return highlights
              end,
            },
            source_name = {
              width = { max = 100 },
              text = function(ctx)
                return "(" .. ctx.source_name .. ")"
              end,
              highlight = "BlinkCmpSource",
            },
          },
        },
        direction_priority = function()
          local ctx = require("blink.cmp").get_context()
          local item = require("blink.cmp").get_selected_item()
          if ctx == nil or item == nil then
            return { "s", "n" }
          end
          local item_text = item.textEdit ~= nil and item.textEdit.newText
            or item.insertText
            or item.label
          local is_multi_line = item_text:find("\n") ~= nil
          -- After showing the menu upwards, we want to maintain that direction
          -- until we re-open the menu, so store the context id in a global variable
          if is_multi_line or vim.g.blink_cmp_upwards_ctx_id == ctx.id then
            vim.g.blink_cmp_upwards_ctx_id = ctx.id
            return { "n", "s" }
          end
          return { "s", "n" }
        end,
      },
    },
    snippets = { preset = "luasnip" },
    fuzzy = { implementation = "lua" },
  },
  config = function(_, opts)
    require("blink.cmp").setup(opts)

    -- Fix: blink.cmp always renders EVERY overload's signature label in the
    -- signature help float (see lua/blink/cmp/signature/window.lua upstream --
    -- it maps `signature_help.signatures` to labels with no filtering). For
    -- something like Express's `app.get()` with 4+ overloads, that means the
    -- whole stack shows every time, even with show_documentation = false.
    -- There's no config flag for "only show the active one", so we patch the
    -- function to trim signature_help down to just the active signature
    -- before it ever reaches the renderer.
    local ok, sig_window = pcall(require, "blink.cmp.signature.window")
    if ok and sig_window and not sig_window.__active_only_patched then
      local original_open = sig_window.open_with_signature_help
      sig_window.open_with_signature_help = function(context, signature_help)
        if signature_help and signature_help.signatures and #signature_help.signatures > 1 then
          local active_idx = (signature_help.activeSignature or 0) + 1
          local active_sig = signature_help.signatures[active_idx]
          if active_sig then
            signature_help = vim.tbl_extend("force", {}, signature_help, {
              signatures = { active_sig },
              activeSignature = 0,
            })
          end
        end
        return original_open(context, signature_help)
      end
      sig_window.__active_only_patched = true
    end
  end,
}
