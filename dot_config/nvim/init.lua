local vim = vim;
--  KeyMappings ------------------
-- remap leader to spacebar
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


-- jj as escape in insert and visual mode
local options = { nowait = true, noremap = true }
vim.keymap.set('i', 'jj', '<Esc>', options)
vim.keymap.set('v', 'jj', '<Esc>', options)
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

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { silent = true, noremap = true, desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { silent = true, noremap = true, desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { silent = true, noremap = true, desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { silent = true, noremap = true, desc = 'Move focus to the upper window' })
-------------------------------------------------------------

------- Options
-- relative line numbers
vim.opt.relativenumber = true
-- and show the absolute line number for the current line
vim.opt.number = true
-- keep current content top + left when splitting
vim.opt.splitright = true
vim.opt.splitbelow = true
-- infinite undo!, NOTE: ends up in ~/.local/state/nvim/undo/
vim.opt.undofile = true

vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

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

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
-- vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true
-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 5

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true

-- never ever folding
vim.opt.foldenable = false
vim.opt.foldmethod = 'manual'
vim.opt.foldlevelstart = 99

-- never show me line breaks if they're not there
vim.opt.wrap = false
vim.opt.textwidth = 79
vim.opt.linebreak = true

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

-- :h laststatus
vim.opt.laststatus = 3
-------------------------------------------------------------------------------
--
-- autocommands
--
-------------------------------------------------------------------------------
-- leave paste mode when leaving insert mode (if it was on)
vim.api.nvim_create_autocmd('InsertLeave', { pattern = '*', command = 'set nopaste' })
vim.api.nvim_create_augroup('AutoFormat', {})
--
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
-------------------------------------------------------------------------------
--
-- plugin configuration
--
-------------------------------------------------------------------------------
require('config.lazy')
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
