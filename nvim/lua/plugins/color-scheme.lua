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
