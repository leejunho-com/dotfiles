return {
  {
    "hat0uma/csvview.nvim",
    ---@module "csvview"
    ---@type CsvView.Options
    opts = {
      view = {
        display_mode = "border",
        show_column_range = true,
        -- number = false,
        -- width = 80,
      },
      parser = { comments = { "#", "//" } },
      keymaps = {
        -- Text objects for selecting fields
        textobject_field_inner = { "if", mode = { "o", "x" } },
        textobject_field_outer = { "af", mode = { "o", "x" } },
        -- Excel-like navigation:
        -- Use <Tab> and <S-Tab> to move horizontally between fields.
        -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
        -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
        jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
        jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
        jump_next_row = { "<Enter>", mode = { "n", "v" } },
        jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
      },
    },

    -- SPACE-t(table) to toggle
    keys = {
      { "<leader>t", "<cmd>CsvViewToggle<cr>", desc = "Toggle CSV View" },
    },

    -- auto toggle
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "csv" },
        callback = function()
          vim.cmd("CsvViewToggle")
        end,
      })
    end,

    -- column color from vscode dark
    config = function()
      local csv_colors = {
        "#CCCCCC", -- Col0
        "#569CD6", -- Col1
        "#DCDCAA", -- Col2
        "#6A9955", -- Col3
        "#CE9178", -- Col4
        "#9CDCFE", -- Col5
        "#B5CEA8", -- Col6
        "#4EC9B0", -- Col7
        -- "#569CD6",
        "#F44747", -- Col8
      }

      for i, col in ipairs(csv_colors) do
        local group = "CsvViewCol" .. (i - 1)
        vim.api.nvim_set_hl(0, group, { fg = col })
      end
    end,
  },
}
