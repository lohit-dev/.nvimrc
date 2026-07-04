return {
  "DrKJeff16/project.nvim", -- fork of the abandoned ahmedkhalf/project.nvim, no
  -- deprecated APIs, actively maintained
  event = "VeryLazy",
  opts = {
    -- detection_methods no longer exists in this fork -- lsp detection is now
    -- its own table, pattern detection is always on via `patterns` below
    lsp = { enabled = true },
    patterns = { ".git", "package.json", "pyproject.toml", "Cargo.toml", "go.mod", ".luarc.json" },
    silent_chdir = true,
    scope_chdir = "global",
  },
  config = function(_, opts)
    require("project").setup(opts) -- module renamed from project_nvim -> project
  end,
}
