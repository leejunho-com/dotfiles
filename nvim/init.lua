-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- clipbaord
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight on yank and copy to system clipboard",
  pattern = "*",
  callback = function()
    vim.highlight.on_yank()
    vim.fn.setreg("+", vim.fn.getreg('"'))
  end,
})
vim.opt.clipboard = "unnamedplus"
