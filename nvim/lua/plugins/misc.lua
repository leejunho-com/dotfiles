return {
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = { -- set to setup table
    },
  },
  {
    "mechatroner/rainbow_csv",
    ft = { "csv", "tsv" },
    config = function()
      vim.cmd([[
      highlight RainbowCol1  guifg=#FFD700
      highlight RainbowCol2  guifg=#FF69B4
      highlight RainbowCol3  guifg=#87CEEB
      highlight RainbowCol4  guifg=#ADFF2F
      highlight RainbowCol5  guifg=#FF4500
      highlight RainbowCol6  guifg=#DA70D6
      highlight RainbowCol7  guifg=#00CED1
      highlight RainbowCol8  guifg=#7CFC00
      highlight RainbowCol9  guifg=#FF6347
      highlight RainbowCol10 guifg=#BA55D3
      highlight RainbowCol11 guifg=#20B2AA
      highlight RainbowCol12 guifg=#32CD32
    ]])
    end,
  },
}
