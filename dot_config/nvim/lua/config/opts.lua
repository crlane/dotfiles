local g = vim.g
local opt = vim.opt
-- remap leader to spacebar
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
g.mapleader = " "
g.maplocalleader = " "
opt.relativenumber = true
-- and show the absolute line number for the current line
opt.number = true
-- keep current content top + left when splitting
opt.splitright = true
opt.splitbelow = true
-- infinite undo!, NOTE: ends up in ~/.local/state/nvim/undo/
opt.undofile = true
opt.shiftwidth = 4
opt.softtabstop = 4
opt.tabstop = 4
opt.expandtab = true
-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
	opt.clipboard = "unnamedplus"
end)
-- case-insensitive search/replace
opt.ignorecase = true
-- unless uppercase in search term
opt.smartcase = true
-- never ever make my terminal beep
opt.vb = true
-- show a column at 80 characters as a guide for long lines
opt.colorcolumn = "80"
-- Decrease update time
opt.updatetime = 250
-- Decrease mapped sequence wait time
opt.timeoutlen = 300
-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
-- Preview substitutions live, as you type!
opt.inccommand = "split"
-- Show which line your cursor is on
opt.cursorline = true
-- Minimal number of screen lines to keep above and below the cursor.
opt.scrolloff = 5
-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
opt.confirm = true
-- never ever folding
opt.foldenable = false
opt.foldmethod = "manual"
opt.foldlevelstart = 99
-- never show me line breaks if they're not there
opt.wrap = false
opt.linebreak = true
-- always draw sign column. prevents buffer moving when adding/deleting sign
opt.signcolumn = "yes"
opt.background = "dark"
--" Decent wildmenu
-- in completion, when there is more than one match,
-- list all matches, and only complete to longest common match
opt.wildmode = "list:longest"
-- when opening a file with a command (like :e),
-- don't suggest files like there:
opt.wildignore = ".hg,.svn,*~,*.png,*.jpg,*.gif,*.min.js,*.swp,*.o,vendor,dist,_site"
-- :h laststatus
opt.laststatus = 3
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
