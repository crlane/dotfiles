-- Bootstrap lazy.nvim
local vim = vim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)


-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        -- import your plugins
        { import = "plugins" },
        -- Git support
        {
            'tpope/vim-fugitive',
            cmd = "Git"
        },
        {
            'airblade/vim-gitgutter',
        },
        {
            'numToStr/Comment.nvim',
            opts = {
                -- add any options here
            }
        },
        -- nice bar at the bottom
        {
            'edkolev/tmuxline.vim',
            config = function()

            end
        },
        -- nice bar at the bottom
        {
            'itchyny/lightline.vim',
            lazy = false, -- also load at start since it's UI
            config = function()
                -- no need to also show mode in cmd line when we have bar
                vim.o.showmode = false
                vim.g.lightline = {
                    colorscheme = "one",
                    active = {
                        left = {
                            { 'mode',     'paste' },
                            { 'readonly', 'filename', 'modified' }
                        },
                        right = {
                            { 'lineinfo' },
                            { 'percent' },
                            { 'fileencoding', 'filetype' }
                        },
                    },
                    component_function = {
                        filename = 'LightlineFilename'
                    },
                }
                function LightlineFilenameInLua(_)
                    if vim.fn.expand('%:t') == '' then
                        return '[No Name]'
                    else
                        return vim.fn.getreg('%')
                    end
                end

                -- https://github.com/itchyny/lightline.vim/issues/657
                vim.api.nvim_exec(
                    [[
                function! g:LightlineFilename()
                    return v:lua.LightlineFilenameInLua()
                endfunction
                ]],
                    true
                )
            end
        },
        -- better %
        {
            'andymass/vim-matchup',
            config = function()
                vim.g.matchup_matchparen_offscreen = { method = "popup" }
            end
        },
        -- auto-cd to root of git project
        {
            'notjedi/nvim-rooter.lua',
            config = function()
                require('nvim-rooter').setup()
            end
        },
        {
            'nvim-telescope/telescope.nvim',
            tag = '0.1.6',
            dependencies = { 'nvim-lua/plenary.nvim' },
            config = function()
                require('telescope').setup {
                    defaults = {
                        -- Default configuration for telescope goes here:
                        -- config_key = value,
                        mappings = {
                            i = {
                                -- map actions.which_key to <C-h> (default: <C-/>)
                                -- actions.which_key shows the mappings for your picker,
                                -- e.g. git_{create, delete, ...}_branch for the git_branches picker
                                -- ["<C-h>"] = "which_key"
                            }
                        }
                    },
                    pickers = {
                        -- Default configuration for builtin pickers goes here:
                        -- picker_name = {
                        --   picker_config_key = value,
                        --   ...
                        -- }
                        -- Now the picker_config_key will be applied every time you call this
                        -- builtin picker
                    },
                    extensions = {
                        -- Your extension configuration goes here:
                        -- extension_name = {
                        --   extension_config_key = value,
                        -- }
                        -- please take a look at the readme of the extension you want to configure
                    }
                }

                local builtin = require('telescope.builtin')
                vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = 'Telescope find files' })
                vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Telescope find files' })
                vim.keymap.set('n', '<leader>g', builtin.live_grep, { desc = 'Telescope live grep' })
                vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'Telescope buffers' })
                vim.keymap.set('n', '<leader>d', builtin.diagnostics, { desc = 'Telescope LSP Diagnostics' })
                vim.keymap.set('n', '<leader>t', builtin.help_tags, { desc = 'Telescope help tags' })
                vim.keymap.set('n', '<leader>k', builtin.keymaps, { desc = 'Normal mode keymaps' })
            end
        },
        {
            "andrewferrier/wrapping.nvim",
            config = function()
                require("wrapping").setup({
                    softener = { markdown = true, rst = true },
                })
            end
        },
        {
            "stevearc/conform.nvim",
            event = { "BufWritePre" },
            cmd = { "ConformInfo" },
            keys = {
                {
                    -- Customize or remove this keymap to your liking
                    "<leader>f",
                    function()
                        require("conform").format({ async = true })
                    end,
                    mode = "",
                    desc = "Format buffer",
                },
            },
            -- This will provide type hinting with LuaLS
            ---@module "conform"
            ---@type conform.setupOpts
            opts = {
                -- Define your formatters
                formatters_by_ft = {
                    lua = { "stylua" },
                    python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
                    javascript = { "prettierd", "prettier", stop_after_first = true },
                    rust = { "rustfmt" },
                    golang = { "gofmt" },
                },
                -- Set default options
                default_format_opts = {
                    lsp_format = "fallback",
                },
                -- Set up format-on-save
                format_on_save = { timeout_ms = 500 },
                -- Customize formatters
                formatters = {
                    shfmt = {
                        prepend_args = { "-i", "2" },
                    },
                },
            },
            init = function()
                -- If you want the formatexpr, here is the place to set it
                vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
            end,
        }
    },

    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "habamax" } },
    -- automatically check for plugin updates
    checker = { enabled = true },
})
