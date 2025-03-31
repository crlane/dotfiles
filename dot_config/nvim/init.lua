local vim = vim;
--  KeyMappings ------------------
-- remap leader to spacebar
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- jj as escape in insert mode
local options = { nowait = true, noremap = true}
vim.keymap.set('i', 'jj', '<Esc>', options)
-- vim.keymap.set('v', 'jj', '<Esc>', options)
-- vim.keymap.set('s', 'jj', '<Esc>')
-- vim.keymap.set('x', 'jj', '<Esc>')
-- vim.keymap.set('c', 'jj', '<Esc>')
-- vim.keymap.set('o', 'jj', '<Esc>')
-- vim.keymap.set('l', 'jj', '<Esc>')
-- vim.keymap.set('t', 'jj', '<Esc>')

-- <leader>p will paste clipboard into buffer
-- <leader>c will copy entire buffer into clipboard
if vim.fn.has('wl-paste') then
    vim.keymap.set('n', '<leader>p', '<cmd>read !wl-paste<cr>')
    vim.keymap.set('n', '<leader>c', '<cmd>w !wl-copy<cr><cr>')
elseif vim.fn.has('pbcopy') then
    vim.keymap.set('n', '<leader>p', '<cmd>read !pbpaste<cr>')
    vim.keymap.set('n', '<leader>c', '<cmd>w !pbcopy<cr><cr>')
end

-- <leader><leader> to stop searching
vim.keymap.set('v', '<leader><leader>', '<cmd>nohlsearch<cr>')
vim.keymap.set('n', '<leader><leader>', '<cmd>nohlsearch<cr>')

-- better window navigation
local options = { silent = true, noremap = true }
vim.keymap.set('n', '<C-h>', '<cmd>wincmd h<cr>', options)
vim.keymap.set('n', '<C-j>', '<cmd>wincmd j<cr>', options)
vim.keymap.set('n', '<C-k>', '<cmd>wincmd k<cr>', options)
vim.keymap.set('n', '<C-l>', '<cmd>wincmd l<cr>', options)
-------------------------------------------------------------

------- Options
-- relative line numbers
vim.opt.relativenumber = true
-- and show the absolute line number for the current line
vim.opt.number = true
-- keep current content top + left when splitting
vim.opt.splitright = true
vim.opt.splitbelow = true
-- infinite undo!
-- NOTE: ends up in ~/.local/state/nvim/undo/
vim.opt.undofile = true

vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true

-- use the system clipboard
vim.opt.clipboard = "unnamed"

-- case-insensitive search/replace
vim.opt.ignorecase = true
-- unless uppercase in search term
vim.opt.smartcase = true

-- never ever make my terminal beep
vim.opt.vb = true

-- show a column at 80 characters as a guide for long lines
vim.opt.colorcolumn = '80'
--- except in Rust where the rule is 100 characters
vim.api.nvim_create_autocmd('Filetype', { pattern = 'rust', command = 'set colorcolumn=100' })

-- never ever folding
vim.opt.foldenable = false
vim.opt.foldmethod = 'manual'
vim.opt.foldlevelstart = 99

-- keep more context on screen while scrolling
vim.opt.scrolloff = 2
-- never show me line breaks if they're not there
vim.opt.wrap = false
-- always draw sign column. prevents buffer moving when adding/deleting sign
vim.opt.signcolumn = 'yes'
vim.opt.background = 'dark'
--" Decent wildmenu
-- in completion, when there is more than one match,
-- list all matches, and only complete to longest common match
vim.opt.wildmode = 'list:longest'
-- when opening a file with a command (like :e),
-- don't suggest files like there:
vim.opt.wildignore = '.hg,.svn,*~,*.png,*.jpg,*.gif,*.min.js,*.swp,*.o,vendor,dist,_site'
vim.opt.laststatus = 3
-------------------------------------------------------------------------------
--
-- autocommands
--
-------------------------------------------------------------------------------
-- leave paste mode when leaving insert mode (if it was on)
vim.api.nvim_create_autocmd('InsertLeave', { pattern = '*', command = 'set nopaste' })
--
-------------------------------------------------------------------------------
--
-- plugin configuration
--
-------------------------------------------------------------------------------
require('config.lazy')
