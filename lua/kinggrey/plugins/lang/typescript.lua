-- TypeScript and JavaScript support
-- Fast TypeScript tooling plus package.json helpers

return {
  {
    "pmizio/typescript-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    ft = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
    },
    opts = function()
      local vue_plugin_path = vim.fn.stdpath("data")
        .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

      local tsserver_plugins = {}
      if vim.fn.isdirectory(vue_plugin_path) == 1 then
        tsserver_plugins = {
          {
            name = "@vue/typescript-plugin",
            location = vue_plugin_path,
            languages = { "vue" },
            configNamespace = "typescript",
          },
        }
      end

      return {
        filetypes = {
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
        },
        settings = {
          separate_diagnostic_server = true,
          publish_diagnostic_on = "insert_leave",
          expose_as_code_action = {
            "add_missing_imports",
            "fix_all",
            "organize_imports",
            "remove_unused",
            "remove_unused_imports",
          },
          tsserver_plugins = tsserver_plugins,
          complete_function_calls = true,
          jsx_close_tag = {
            enable = false,
            filetypes = { "javascriptreact", "typescriptreact" },
          },
          tsserver_file_preferences = {
            includeCompletionsForModuleExports = true,
            includeInlayEnumMemberValueHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = true,
            quotePreference = "auto",
          },
        },
      }
    end,
  },
  {
    "vuki656/package-info.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    ft = { "json" },
    config = function()
      require("package-info").setup({
        autostart = true,
        hide_up_to_date = true,
      })
    end,
  },
}
