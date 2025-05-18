-- Set leader key
vim.g.mapleader = '\\'
vim.g.maplocalleader = '\\'
vim.o.timeoutlen = 3000

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Emacs style keymap for INSERT mode
vim.keymap.set('i', '<C-a>', '<Home>', opts)      -- line start
vim.keymap.set('i', '<C-e>', '<End>', opts)       -- line end
vim.keymap.set('i', '<C-b>', '<Left>', opts)      -- backward char
vim.keymap.set('i', '<C-f>', '<Right>', opts)     -- forward charchar
vim.keymap.set('i', '<M-b>', '<Esc>bi', opts)     -- move back by word
vim.keymap.set('i', '<M-f>', '<Esc>ea', opts)     -- move forward by word
vim.keymap.set('i', '<C-p>', '<Up>', opts)        -- previous line
vim.keymap.set('i', '<C-n>', '<Down>', opts)      -- next line
vim.keymap.set('i', '<C-d>', '<Del>', opts)       -- delete char under cursor
vim.keymap.set('i', '<C-h>', '<BS>', opts)        -- backspace
vim.keymap.set('i', '<C-k>', '<C-o>D', opts)      -- kill to EOL
vim.keymap.set('i', '<C-w>', '<C-g>u<C-w>', opts) -- delete previous word
vim.keymap.set('i', '<C-u>', '<C-g>u<C-u>', opts) -- delete to BOL

-- For conciseness
local opts = { noremap = true, silent = true }

-- save file
vim.keymap.set('n', '<C-s>', '<cmd> w <CR>', opts)

-- save file without auto-formatting
vim.keymap.set('n', '<leader>sn', '<cmd>noautocmd w <CR>', opts)

-- quit file
vim.keymap.set('n', '<C-q>', '<cmd> q <CR>', opts)

-- delete single character without copying into register
vim.keymap.set('n', 'x', '"_x', opts)

-- Vertical scroll and center
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)

-- Find and center
vim.keymap.set('n', 'n', 'nzzzv', opts)
vim.keymap.set('n', 'N', 'Nzzzv', opts)

-- Resize with arrows
vim.keymap.set('n', '<C-M-h>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<C-M-j>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<C-M-k>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<C-M-l>', ':vertical resize +2<CR>', opts)

-- Buffers
vim.keymap.set('n', '<Tab>', ':bnext<CR>', opts)
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts)
vim.keymap.set('n', '<leader>x', ':bdelete!<CR>', opts) -- close buffer
vim.keymap.set('n', '<leader>b', '<cmd> enew <CR>', opts) -- new buffer

-- Window management
vim.keymap.set('n', '<leader>%', '<C-w>v', opts) -- split window vertically
vim.keymap.set('n', '<leader>"', '<C-w>s', opts) -- split window horizontally
vim.keymap.set('n', '<leader>se', '<C-w>=', opts) -- make split windows equal width & height
vim.keymap.set('n', '<leader>x', ':close<CR>', opts) -- close current split window

-- Navigate between splits
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', opts)
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', opts)
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', opts)
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', opts)

-- Tabs
vim.keymap.set('n', '<leader>to', ':tabnew<CR>', opts) -- open new tab
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', opts) -- close current tab
vim.keymap.set('n', '<leader>tn', ':tabn<CR>', opts) --  go to next tab
vim.keymap.set('n', '<leader>tp', ':tabp<CR>', opts) --  go to previous tab
-- Toggle line wrapping
vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', opts)

-- Stay in indent mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- Keep last yanked when pasting
vim.keymap.set('v', 'p', '"_dP', opts)

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
