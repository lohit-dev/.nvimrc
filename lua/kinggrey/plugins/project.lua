return {
  "ahmedkhalf/project.nvim",
  event = "VeryLazy",
  opts = {
    detection_methods = { "lsp", "pattern" },
    patterns = { ".git", "package.json", "pyproject.toml", "Cargo.toml", "go.mod", ".luarc.json" },
    silent_chdir = true,
    scope_chdir = "global",
  },
  config = function(_, opts)
    require("project_nvim").setup(opts)
  end,
}
