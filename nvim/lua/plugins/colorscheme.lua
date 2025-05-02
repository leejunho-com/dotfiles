return {
  "Mofiqul/vscode.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.o.background = "dark"

    local c = require("vscode.colors").get_colors()
    require("vscode").setup({
      transparent = true,
      italic_comments = true,
      underline_links = true,
      disable_nvimtree_bg = true,
      terminal_colors = true,
      color_overrides = {
        vscLineNumber = "#FFFFFF",
      },
      group_overrides = {
        Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
        NormalFloat = { bg = "NONE" },
        FloatBorder = { bg = "NONE" },
        FloatTitle = { bg = "NONE" },
        Pmenu = { bg = "NONE" },
        PmenuSel = { bg = "NONE" },
        WhichKeyFloat = { bg = "NONE" },
        BufferLineFill = { bg = "NONE" },
        BufferLineBackground = { bg = "NONE" },
        BufferLineBufferVisible = { bg = "NONE" },
        BufferLineBufferSelected = { bg = "NONE" },
        BufferLineSeparator = { bg = "NONE" },
        BufferLineSeparatorVisible = { bg = "NONE" },
        BufferLineSeparatorSelected = { bg = "NONE" },
      },
    })

    vim.cmd.colorscheme("vscode")
  end,
}
