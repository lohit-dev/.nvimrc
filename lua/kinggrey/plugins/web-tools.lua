-- web-tools.nvim
-- Neovim plugin for web developers. Browser-sync | http/css lsp | hurl/curl | npm/yarn/npx
-- https://github.com/ray-x/web-tools.nvim

return {
  "ray-x/web-tools.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("web-tools").setup({
      keymaps = {
        rename = nil, -- by default use same setup of lspconfig
        repeat_rename = ".", -- . to repeat
      },
      hurl = {
        -- hurl default
        show_headers = false, -- do not show http headers
        floating = false, -- use floating windows (need guihua.lua)
        json5 = false, -- use json5 parser require json5 treesitter
        formatters = {
          -- format the result by filetype
          json = { "jq" },
          html = { "prettier", "--parser", "html" },
        },
      },
    })
  end,
  ft = { "html", "css", "javascript", "typescript", "hurl" },
}

