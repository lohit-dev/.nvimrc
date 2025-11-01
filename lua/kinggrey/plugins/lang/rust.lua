-- Rust language support
-- Tools for Rust development in Neovim

return {
  -- Rustaceanvim - Rust Analyzer integration
  {
    "mrcjkb/rustaceanvim",
    version = "^5", -- Latest version
    lazy = false, -- This plugin is already lazy
    ft = { "rust" },
    config = function()
      vim.g.rustaceanvim = {
        -- Plugin configuration
        tools = {},
        -- LSP configuration
        server = {
          on_attach = function(client, bufnr)
            vim.keymap.set("n", "<leader>a", function()
              vim.cmd.RustLsp("codeAction") -- supports rust-analyzer's grouping
              -- or vim.lsp.buf.codeAction() if you don't want grouping.
            end, { silent = true, buffer = bufnr, desc = "Rust code actions" })

            -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
            vim.keymap.set(
              "n",
              "K", -- Override default K
              function()
                vim.cmd.RustLsp({ "hover", "actions" })
              end,
              { silent = true, buffer = bufnr, desc = "Rust hover actions" }
            )
          end,
          settings = {
            ["rust-analyzer"] = {
              -- Enable check on save with clippy
              checkOnSave = true,
            },
          },
        },
      }
    end,
  },

  -- Crates.nvim - Cargo.toml dependency management
  {
    "Saecki/crates.nvim",
    ft = { "toml" },
    config = function()
      require("crates").setup({
        popup = {
          autofocus = true,
        },
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
}
