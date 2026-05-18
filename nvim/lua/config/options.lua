-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.clipboard = "unnamedplus"

-- OSC 52 only over SSH; locally Ghostty handles clipboard natively
-- tmux panes don't inherit SSH env vars, so also check tmux session environment
local function is_ssh()
  if os.getenv("SSH_CLIENT") or os.getenv("SSH_TTY") or os.getenv("SSH_CONNECTION") then
    return true
  end
  if os.getenv("TMUX") then
    local result = vim.fn.system("tmux show-environment SSH_CONNECTION 2>/dev/null")
    return result:match("^SSH_CONNECTION=") ~= nil
  end
  return false
end

if is_ssh() then
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
      ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
      ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
  }
end
