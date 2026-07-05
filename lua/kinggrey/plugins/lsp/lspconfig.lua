-- nvim-lspconfig
-- LSP configuration
-- https://github.com/neovim/nvim-lspconfig

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
    { "mason-org/mason.nvim", opts = {} },
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    { "j-hui/fidget.nvim", opts = {} },
    "saghen/blink.cmp",
  },
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or "n"
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end
        map("grn", vim.lsp.buf.rename, "[R]e[n]ame")

        local function dedupe(items)
          local seen, unique = {}, {}
          for _, item in ipairs(items) do
            local key = item.filename .. ":" .. item.lnum .. ":" .. item.col
            if not seen[key] then
              seen[key] = true
              table.insert(unique, item)
            end
          end
          return unique
        end

        map("gd", function()
          vim.lsp.buf.definition({
            on_list = function(options)
              local items = dedupe(options.items)
              if #items == 1 then
                vim.cmd("edit " .. vim.fn.fnameescape(items[1].filename))
                vim.api.nvim_win_set_cursor(0, { items[1].lnum, items[1].col - 1 })
              else
                vim.fn.setqflist({}, " ", { title = options.title, items = items })
                require("telescope.builtin").quickfix()
              end
            end,
          })
        end, "[G]oto [D]efinition")

        map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
        map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
        map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
        -- WARN: This is not Goto Definition, this is Goto Declaration.
        map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")
        map(
          "gW",
          require("telescope.builtin").lsp_dynamic_workspace_symbols,
          "Open Workspace Symbols"
        )
        map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")
        ---@param client vim.lsp.Client
        ---@param method vim.lsp.protocol.Method
        ---@param bufnr? integer some lsp support methods only in specific files
        ---@return boolean
        local function client_supports_method(client, method, bufnr)
          if vim.fn.has("nvim-0.11") == 1 then
            return client:supports_method(method, bufnr)
          else
            return client.supports_method(method, { bufnr = bufnr })
          end
        end
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if
          client
          and client_supports_method(
            client,
            vim.lsp.protocol.Methods.textDocument_documentHighlight,
            event.buf
          )
        then
          local highlight_augroup =
            vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
            end,
          })
        end
        if
          client
          and client_supports_method(
            client,
            vim.lsp.protocol.Methods.textDocument_inlayHint,
            event.buf
          )
        then
          map("<leader>uh", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
          end, "[T]oggle Inlay [H]ints")
        end
      end,
    })
    -- See :help vim.diagnostic.Opts
    vim.diagnostic.config({
      severity_sort = true,
      float = { border = "rounded", source = "if_many" },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = "󰅚 ",
          [vim.diagnostic.severity.WARN] = "󰀪 ",
          [vim.diagnostic.severity.INFO] = "󰋽 ",
          [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
      } or {},
      virtual_text = {
        source = "if_many",
        spacing = 2,
        format = function(diagnostic)
          local diagnostic_message = {
            [vim.diagnostic.severity.ERROR] = diagnostic.message,
            [vim.diagnostic.severity.WARN] = diagnostic.message,
            [vim.diagnostic.severity.INFO] = diagnostic.message,
            [vim.diagnostic.severity.HINT] = diagnostic.message,
          }
          return diagnostic_message[diagnostic.severity]
        end,
      },
    })
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    local servers = {
      clangd = {},
      gopls = {
        settings = {
          gopls = {
            analyses = {
              shadow = true,
              unusedparams = true,
            },
            gofumpt = true,
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            staticcheck = true,
          },
        },
      },
      pyright = {},
      -- Web development servers
      html = {},
      cssls = {},
      eslint = {},
      jsonls = {},
      vue_ls = {},
      -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
      lua_ls = {
        -- cmd = { ... },
        -- filetypes = { ... },
        -- capabilities = {},
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
          },
        },
      },
    }
    -- Ensure the servers and tools above are installed
    --
    -- To check the current status of installed tools and/or manually install
    -- other tools, you can run
    --    :Mason
    --
    -- You can press `g?` for help in this menu.
    --
    -- `mason` had to be setup earlier: to configure its options see the
    -- `dependencies` table for `nvim-lspconfig` above.
    --
    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    require("mason-lspconfig").setup({
      ensure_installed = vim.tbl_keys(servers),
      automatic_installation = false,
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities =
            vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
          require("lspconfig")[server_name].setup(server)
        end,
      },
    })

    require("mason-tool-installer").setup({
      ensure_installed = {
        "gofumpt",
        "goimports",
        "markdownlint",
        "prettierd",
        "stylua",
        "typescript-language-server",
      },
    })
  end,
}
