return {
  "numToStr/Comment.nvim",
  event = "VeryLazy",
  opts = {
    toggler = {
      line = "<leader>/",
      block = "gbc",
    },
    opleader = {
      line = "gc",
      block = "gb",
    },
  },
  config = function(_, opts)
    require("Comment").setup(opts)

    vim.keymap.set("v", "<leader>/", function()
      require("Comment.api").toggle.linewise(vim.fn.visualmode())
    end, { desc = "Toggle comment" })
  end,
}
