-- persistence.nvim
-- Session management: auto-save per-project session on exit, restore on demand
-- https://github.com/folke/persistence.nvim

return {
  "folke/persistence.nvim",
  event = "BufReadPre", -- only load on an actual file open, not on the dashboard
  opts = {},
  keys = {
    {
      "<leader>qs",
      function()
        require("persistence").load()
      end,
      desc = "[Q]uit/session: [S]tart last session for this cwd",
    },
    {
      "<leader>ql",
      function()
        require("persistence").load({ last = true })
      end,
      desc = "[Q]uit/session: Load [L]ast session (any cwd)",
    },
    {
      "<leader>qd",
      function()
        require("persistence").stop()
      end,
      desc = "[Q]uit/session: [D]on't save current session on exit",
    },
  },
}
