local map = vim.keymap.set
local hascmd = vim.fn.has

map('n', '<Space>', '<Nop>', { silent = true })

-- jj as escape in insert mode
map('i', 'jj', '<Esc>', { nowait = true, noremap = true })
--
-- <leader>p will paste clipboard into buffer
-- <leader>c will copy entire buffer into clipboard
if hascmd('wl-paste') then
  map('n', '<leader>p', '<cmd>read !wl-paste<cr>')
  map('n', '<leader>c', '<cmd>w !wl-copy<cr><cr>')
elseif hascmd('pbcopy') then
  map('n', '<leader>p', '<cmd>read !pbpaste<cr>')
  map('n', '<leader>c', '<cmd>w !pbcopy<cr><cr>')
end

-- <leader><leader> to stop searching
map({ 'v', 'n' }, '<leader><leader>', '<cmd>nohlsearch<cr>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
map('n', '<C-h>', '<C-w><C-h>', { silent = true, noremap = true, desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { silent = true, noremap = true, desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { silent = true, noremap = true, desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { silent = true, noremap = true, desc = 'Move focus to the upper window' })
--
-- after jumping to a file, jump back then previous position
-- :h jumpmotion
map('n', 'gb', '<C-o>', { silent = true, noremap = true, desc = '[G]oto [B]ack in jump buffer' })
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
