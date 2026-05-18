-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.clipboard = "unnamedplus"

-- OSC 52 copy-only: paste via OSC 52 doesn't work inside tmux (tmux intercepts
-- the query and responds with its own buffer, not the host terminal's clipboard).
-- For paste over SSH, use Ghostty terminal paste (Cmd+V) in insert mode.
local function get_paste()
  if vim.fn.has('mac') == 1 then
    return { 'pbpaste' }
  elseif os.getenv('WAYLAND_DISPLAY') then
    return { 'wl-paste', '--no-newline' }
  elseif os.getenv('DISPLAY') then
    return { 'xclip', '-selection', 'clipboard', '-o' }
  else
    return require('vim.ui.clipboard.osc52').paste('+')
  end
end

local paste = get_paste()
vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = paste,
    ['*'] = paste,
  },
}
