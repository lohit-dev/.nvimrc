return {
  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "3rd/image.nvim", -- add this

      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      lang = "javascript",
      image_support = true,
    },
  },
  {
    "3rd/image.nvim",
    opts = {
      backend = "kitty", -- Ghostty speaks the kitty graphics protocol
      tmux_show_only_in_active_window = true,
      editor_only_render_when_focused = true,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "notify", "" },
      integrations = {
        markdown = {
          enabled = true,
          download_remote_images = true, -- leetcode's images are remote URLs
          only_render_image_at_cursor = true,
        },
      },
    },
  },
}
