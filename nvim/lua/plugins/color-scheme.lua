return {
  "Mofiqul/vscode.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.o.background = "dark"

    local bg_transparent = true

    local function apply_theme()
      local c = require("vscode.colors").get_colors()
      require("vscode").setup({
        transparent = bg_transparent,
        italic_comments = true,
        underline_links = true,
        disable_nvimtree_bg = true,
        terminal_colors = true,
        color_overrides = {
          vscBack = "#000000",
          vscLineNumber = "#ffffff",
        },
        group_overrides = {
          Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
        },
      })

      vim.cmd.colorscheme("vscode")

      -- csv-column-color
      local csv_colors = {
        "#FFFFFF", -- Col0
        "#569CD6", -- Col1
        "#DCDCAA", -- Col2
        "#6A9955", -- Col3
        "#CE9178", -- Col4
        "#9CDCFE", -- Col5
        "#4EC9B0", -- Col7
        "#C586C0", -- Col8
        "#808080", -- Col9
        "#F44747", -- Col9
      }

      for i, col in ipairs(csv_colors) do
        local group = "CsvViewCol" .. (i - 1)
        vim.api.nvim_set_hl(0, group, { fg = col })
      end

      vim.cmd([[
          "highlight Normal guibg=NONE ctermbg=NONE
          "highlight NormalNC guibg=NONE ctermbg=NONE
          "highlight NormalFloat guibg=NONE ctermbg=NONE
          "highlight FloatBorder guibg=NONE ctermbg=NONE
          highlight TabLineFill guibg=NONE ctermbg=NONE
          "highlight TabLineSel guibg=NONE ctermbg=NONE
          "highlight TabLine guibg=NONE ctermbg=NONE
          highlight StatusLine guibg=NONE ctermbg=NONE
    ]])
      if bg_transparent then
        local groups = { "Normal", "NormalNC", "NormalFloat", "FloatBorder", "StatusLine", "SignColumn" }
        for _, group in ipairs(groups) do
          vim.api.nvim_set_hl(0, group, { bg = "NONE" })
        end
      end
    end

    local function toggle_transparency()
      bg_transparent = not bg_transparent
      apply_theme()
    end

    apply_theme()

    vim.keymap.set(
      "n",
      "<leader>uu",
      toggle_transparency,
      { noremap = true, silent = true, desc = "Toggle background transparency" }
    )
  end,
}
