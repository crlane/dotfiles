-- LSP configs
return {
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
            -- lua 
            lspconfig.lua_ls.setup{
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
    }
}
