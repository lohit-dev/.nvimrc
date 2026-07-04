return {
  "catgoose/nvim-colorizer.lua", -- was norcalli/nvim-colorizer.lua (abandoned,
  config = function()
    require("colorizer").setup({
      "*",
      css = { rgb_fn = true },
    })

  end,
}
