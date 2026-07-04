-- nvim-treesitter
-- Highlight, edit, and navigate code
-- https://github.com/nvim-treesitter/nvim-treesitter

return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "neovim-treesitter/treesitter-parser-registry",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  lazy = false,
  branch = "master",
  build = ":TSUpdate",
  main = "nvim-treesitter.configs", -- Sets main module to use for opts
  -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
  opts = {
    ensure_installed = {
      "bash",
      "c",
      "diff",
      "html",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "query",
      "vim",
      "vimdoc",
    },
    -- Autoinstall languages that are not installed
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { "rust", "go" },
    },
    indent = { enable = true, disable = { "ruby" } },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["an"] = "@block.outer",
          ["in"] = "@block.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_previous_start = {
          ["[n"] = "@block.outer",
          ["[N"] = "@function.outer",
        },
        goto_next_start = {
          ["]n"] = "@block.outer",
          ["]N"] = "@function.outer",
        },
      },
    },
  },
  -- There are additional nvim-treesitter modules that you can use to interact
  -- with nvim-treesitter. You should go explore a few and see what interests you:
  --
  --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
  --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
  --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
}
