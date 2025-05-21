return {
  {
    "LazyVim/LazyVim",
    lazy = false,
    keys = {
      { "<C-a>", "<Home>", mode = "i", desc = "Emacs: line start" },
      { "<C-e>", "<End>", mode = "i", desc = "Emacs: line end" },
      { "<C-b>", "<Left>", mode = "i", desc = "Emacs: move left" },
      { "<C-f>", "<Right>", mode = "i", desc = "Emacs: move right" },
      { "<M-b>", "<Esc>bi", mode = "i", desc = "Emacs: word back" },
      { "<M-f>", "<Esc>ea", mode = "i", desc = "Emacs: word forward" },
      { "<C-p>", "<Up>", mode = "i", desc = "Emacs: prev line" },
      { "<C-n>", "<Down>", mode = "i", desc = "Emacs: next line" },
      { "<C-d>", "<Del>", mode = "i", desc = "Emacs: delete char" },
      { "<C-h>", "<BS>", mode = "i", desc = "Emacs: backspace" },
      { "<C-k>", "<C-o>D", mode = "i", desc = "Emacs: kill line" },
      { "<C-w>", "<C-g>u<C-w>", mode = "i", desc = "Emacs: delete word" },
      { "<C-u>", "<C-g>u<C-u>", mode = "i", desc = "Emacs: delete to bol" },
    },
  },
  {
    "blink.cmp",
    opts = function(_, opts)
      opts.keymap = {
        preset = "enter",
        ["<Tab>"] = { "select_and_accept" },
      }
    end,
  },
  {
    "folke/noice.nvim",
    keys = {
      { "<C-b>", false, mode = { "i" } },
      { "<C-f>", false, mode = { "i" } },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "<C-k>", false, mode = "i" }
    end,
  },
}
