-- nvim-ts-autotag
-- Autoclose and rename HTML/JSX tags using treesitter
-- https://github.com/windwp/nvim-ts-autotag

return {
  "windwp/nvim-ts-autotag",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  ft = { "html", "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte", "vue", "tsx", "jsx" },
  config = function()
    require("nvim-ts-autotag").setup({
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = false,
      },
    })
  end,
}

