-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "x", '"_x', { noremap = true, silent = true })

vim.keymap.set({ "n", "x" }, "<leader>p", '"0p', { desc = "paste from yank register" })
vim.keymap.set("x", "<leader>P", function()
  vim.cmd('normal! "_dP')
end, { desc = "replace without overwriting register" })
