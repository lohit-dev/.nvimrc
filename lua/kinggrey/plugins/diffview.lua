-- Diffview
-- VS Code style git diff panels and file history

return {
  "sindrets/diffview.nvim",
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewFileHistory",
    "DiffviewFocusFiles",
    "DiffviewToggleFiles",
    "DiffviewRefresh",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Open Diffview" },
  },
  opts = {
    enhanced_diff_hl = true,
    use_icons = true,
    file_panel = {
      win_config = {
        position = "left",
        width = 38,
      },
    },
    view = {
      default = {
        layout = "diff2_horizontal",
      },
      merge_tool = {
        layout = "diff3_horizontal",
      },
      file_history = {
        layout = "diff2_horizontal",
      },
    },
  },
}
