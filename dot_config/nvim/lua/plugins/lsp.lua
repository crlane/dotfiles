-- LSP configs
return {
    {
        'neovim/nvim-lspconfig',
        config = function()
            -- Setup language servers.
            local lspconfig = require('lspconfig')

            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            -- typescript
            lspconfig.ts_ls.setup {
                capabilities = capabilities,
            }
            -- lua
            lspconfig.lua_ls.setup {
                capabilities = capabilities,
            }
            -- python
            -- lspconfig.jedi_language_server.setup {}
            lspconfig.pylsp.setup {
                capabilities = capabilities,
                plugins = {
                    ruff = {
                        enabled = true,       -- Enable the plugin
                        formatEnabled = true, -- Enable formatting using ruffs formatter
                        -- executable = "<path-to-ruff-bin>", -- Custom path to ruff
                        -- config = "<path_to_custom_ruff_toml>", -- Custom config for ruff to use
                        extendSelect = { "I" },          -- Rules that are additionally used by ruff
                        extendIgnore = { "C90" },        -- Rules that are additionally ignored by ruff
                        format = { "I" },                -- Rules that are marked as fixable by ruff that should be fixed when running textDocument/formatting
                        severities = { ["D212"] = "I" }, -- Optional table of rules where a custom severity is desired
                        unsafeFixes = false,             -- Whether or not to offer unsafe fixes as code actions. Ignored with the "Fix All" action

                        -- Rules that are ignored when a pyproject.toml or ruff.toml is present:
                        lineLength = 88,                                 -- Line length to pass to ruff checking and formatting
                        exclude = { "__about__.py" },                    -- Files to be excluded by ruff checking
                        select = { "F" },                                -- Rules to be enabled by ruff
                        ignore = { "D210" },                             -- Rules to be ignored by ruff
                        perFileIgnores = { ["__init__.py"] = "CPY001" }, -- Rules that should be ignored for specific files
                        preview = false,                                 -- Whether to enable the preview style linting and formatting.
                        targetVersion = "py310",                         -- The minimum python version to target (applies for both lint
                    }
                }
            }
            -- lspconfig.ruff.setup {
            --     capabilities = capabilities,
            --     init_options = {
            --         settings = {
            --             configurationPreference = 'filesystemFirst',
            --             lineLength = 90,
            --             fixAll = true,
            --             organizeImports = true
            --         }
            --     }
            -- }
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
                        root_dir = lspconfig.util.find_git_ancestor,
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
                vim.api.nvim_create_autocmd('BufWritePre', {
                    pattern = { "*.sh", "*.bash" },
                    group = "AutoFormat",
                    -- uses shfmt
                    callback = function(_)
                        vim.lsp.buf.format()
                    end
                })
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
            vim.api.nvim_create_autocmd('BufWritePre', {
                pattern = { "*.zig", "*.zon" },
                group = "AutoFormat",
                callback = function(_)
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
            -- eslint
            lspconfig.eslint.setup({
                flags = {
                    allow_incremental_sync = false,
                    debounce_text_changes = 1000
                }
            })
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
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = ev.buf, desc = "LSP Goto definition" })
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = ev.buf, desc = "LSP Goto declartion" })
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation,
                        { buffer = ev.buf, desc = "LSP Goto implementation" })
                    vim.keymap.set('n', 'gb', '<C-o>',
                        { buffer = ev.buf, desc = "Go back in jumplist", nowait = true, noremap = true })
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = ev.buf, desc = "LSP Hover" })
                    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help,
                        { buffer = ev.buf, desc = "LSP Signature Help" })

                    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder,
                        { buffer = ev.buf, desc = "LSP add workspace folder" })
                    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder,
                        { buffer = ev.buf, desc = "LSP remove workspace folder" })
                    vim.keymap.set('n', '<leader>wl', function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, { buffer = ev.buf, desc = "LSP list workspace folders" })

                    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition,
                        { buffer = ev.buf, desc = "LSP type definition" })
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = ev.buf, desc = "LSP rename" })
                    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action,
                        { buffer = ev.buf, desc = "LSP code action" })
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = ev.buf, desc = "LSP Goto references" })
                    vim.keymap.set('n', '<leader>f', function()
                        vim.lsp.buf.format { async = true }
                    end, { buffer = ev.buf, desc = "LSP format" })
                end,
            })
        end
    },
    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
    }
}
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
