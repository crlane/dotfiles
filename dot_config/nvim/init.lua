--  KeyMappings ------------------
-- remap leader to spacebar
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "

-- quick-open
vim.keymap.set('', '<C-p>', '<cmd>Files<cr>')
-- search buffers
vim.keymap.set('n', '<leader>;', '<cmd>Buffers<cr>')

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
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
-- then, setup!
require("lazy").setup({
    -- main color scheme
    {
       "tiagovla/tokyodark.nvim",
        lazy = false,
        opts = {
            -- custom options here
        },
        config = function(_, opts)
            require("tokyodark").setup(opts) -- calling setup is optional
            vim.cmd [[colorscheme tokyodark]]
        end,
    },
    {
       "navarasu/onedark.nvim",
    },
    {
        'maxmx03/solarized.nvim',
        lazy = false,
        priority = 1000,
        config = function()
          vim.o.background = 'dark' -- or 'light'

          vim.cmd.colorscheme 'solarized'
        end,
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
                        { 'mode', 'paste' },
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
            function LightlineFilenameInLua(opts)
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
    -- 'airblade/vim-rooter'
    {
        'notjedi/nvim-rooter.lua',
        config = function()
            require('nvim-rooter').setup()
        end
    },
    {
    'nvim-telescope/telescope.nvim', tag = '0.1.6',
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = function() 
          require('telescope').setup{
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

        vim.api.nvim_create_user_command('Files', function(arg)
            local builtins = require('telescope.builtin')
            builtins.find_files(arg)
            end, { bang = true, nargs = '?', complete = "dir" }
        )
      end
    },
    {
       'tpope/vim-fugitive',
       cmd = "Git"
    },
    {
       'airblade/vim-gitgutter',
    },
    {
       'tomtom/tcomment_vim',
    },
    -- LSP
    {
        'neovim/nvim-lspconfig',
        config = function()
            -- Setup language servers.
            local lspconfig = require('lspconfig')

            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            -- typescript
            lspconfig.ts_ls.setup{
                capabilities = capabilities,
            }
            
            -- python
            lspconfig.ruff.setup{
                capabilities = capabilities,
            }

            -- Rust
            lspconfig.rust_analyzer.setup {
                capabilities = capabilities,
                -- Server-specific settings. See `:help lspconfig-setup`
                settings = {
                    ["rust-analyzer"] = {
                        cargo = {

                        },
                        imports = {
                            group = {
                                enable = false,
                            },
                        },
                        completion = {
                            postfix = {
                                enable = false,
                            },
                        },
                    },
                },
            }

            -- Bash LSP
            local configs = require 'lspconfig.configs'
            if not configs.bash_lsp and vim.fn.executable('bash-language-server') == 1 then
                configs.bash_lsp = {
                    default_config = {
                        cmd = { 'bash-language-server', 'start' },
                        filetypes = { 'sh' },
                        root_dir = require('lspconfig').util.find_git_ancestor,
                        init_options = {
                            settings = {
                                args = {}
                            }
                        }
                    }
                }
            end
            if configs.bash_lsp then
                lspconfig.bash_lsp.setup {}
            end

            -- Zig
			-- don't show parse errors in a separate window
            vim.g.zig_fmt_parse_errors = 0
            -- disable format-on-save from `ziglang/zig.vim`
            vim.g.zig_fmt_autosave = 0
            -- enable  format-on-save from nvim-lspconfig + ZLS
            --
            -- Formatting with ZLS matches `zig fmt`.
            -- The Zig FAQ answers some questions about `zig fmt`:
            -- https://github.com/ziglang/zig/wiki/FAQ
            vim.api.nvim_create_autocmd('BufWritePre',{
              pattern = {"*.zig", "*.zon"},
              callback = function(ev)
                vim.lsp.buf.format()
              end
            })
            lspconfig.zls.setup {
              -- Server-specific settings. See `:help lspconfig-setup`

              -- omit the following line if `zls` is in your PATH
              -- cmd = { '/path/to/zls_executable' },
              -- There are two ways to set config options:
              --   - edit your `zls.json` that applies to any editor that uses ZLS
              --   - set in-editor config options with the `settings` field below.
              --
              -- Further information on how to configure ZLS:
              -- https://zigtools.org/zls/configure/
              settings = {
                zls = {
                  -- Whether to enable build-on-save diagnostics
                  --
                  -- Further information about build-on save:
                  -- https://zigtools.org/zls/guides/build-on-save/
                  -- enable_build_on_save = true,

                  -- omit the following line if `zig` is in your PATH
                  -- zig_exe_path = '/path/to/zig_executable'
                }
              }
            }   

            -- Global mappings.
            -- See `:help vim.diagnostic.*` for documentation on any of the below functions
            vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
            vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

            -- Use LspAttach autocommand to only map the following keys
            -- after the language server attaches to the current buffer
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    -- Enable completion triggered by <c-x><c-o>
                    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                    -- Buffer local mappings.
                    -- See `:help vim.lsp.*` for documentation on any of the below functions
                    local opts = { buffer = ev.buf }
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
                    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
                    vim.keymap.set('n', '<leader>wl', function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, opts)
                    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                    vim.keymap.set('n', '<leader>f', function()
                        vim.lsp.buf.format { async = true }
                    end, opts)

                    -- local client = vim.lsp.get_client_by_id(ev.data.client_id)

                    -- When https://neovim.io/doc/user/lsp.html#lsp-inlay_hint stabilizes
                    -- *and* there's some way to make it only apply to the current line.
                    -- if client.server_capabilities.inlayHintProvider then
                    --     vim.lsp.inlay_hint(ev.buf, true)
                    -- end

                    -- None of this semantics tokens business.
                    -- https://www.reddit.com/r/neovim/comments/143efmd/is_it_possible_to_disable_treesitter_completely/
                    -- client.server_capabilities.semanticTokensProvider = nil
                end,
            })
        end
    },
    {
        "hrsh7th/nvim-cmp",
        -- load cmp on InsertEnter
        event = "InsertEnter",
        -- these dependencies will only be loaded when cmp loads
        -- dependencies are always lazy-loaded unless specified otherwise
        dependencies = {
            'neovim/nvim-lspconfig',
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets"
        },
        config = function()
            local cmp = require'cmp'
            cmp.setup({
                snippet = {
                    -- REQUIRED by nvim-cmp. get rid of it once we can
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end
                },
                window = {
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    -- Accept currently selected item.
                    -- Set `select` to `false` to only confirm explicitly selected items.
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                }, {
                    { name = 'path' },

                }),
                experimental = {
                    ghost_text = true,
                },
            })

            -- Enable completing paths in :
            cmp.setup.cmdline(':', {
                sources = cmp.config.sources({
                    { name = 'path' }
                })
            })

            require("luasnip.loaders.from_vscode").lazy_load()
        end
    },
    -- language support
    -- zig
    {
      'ziglang/zig',
      ft = {"zig"}
    },
    -- terraform
    {
        'hashivim/vim-terraform',
        ft = { "terraform" },
    },
    -- svelte
    {
        'evanleck/vim-svelte',
        ft = { "svelte" },
    },
    -- toml
    'cespare/vim-toml',
    -- jinja
    'lepture/vim-jinja',
    -- yaml
    {
        "cuducos/yaml.nvim",
        ft = { "yaml" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
    },
    -- rust
    {
        'rust-lang/rust.vim',
        ft = { "rust" },
        config = function()
            vim.g.rustfmt_autosave = 1
            vim.g.rustfmt_emit_files = 1
            vim.g.rustfmt_fail_silently = 0
            vim.g.rust_clip_command = 'wl-copy'
        end
    },
    -- markdown
    {
        'plasticboy/vim-markdown',
        ft = { "markdown" },
        dependencies = {
            'godlygeek/tabular',
        },
        config = function()
            -- never ever fold!
            vim.g.vim_markdown_folding_disabled = 1
            -- support front-matter in .md files
            vim.g.vim_markdown_frontmatter = 1
            -- 'o' on a list item should insert at same level
            vim.g.vim_markdown_new_list_item_indent = 0
            -- don't add bullets when wrapping:
            -- https://github.com/preservim/vim-markdown/issues/232
            vim.g.vim_markdown_auto_insert_bullets = 0
        end
    },
})
