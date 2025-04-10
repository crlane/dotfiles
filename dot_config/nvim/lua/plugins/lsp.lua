-- LSP configs
return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      -- Setup language servers.
      local lspconfig = require('lspconfig')
      -- typescript
      lspconfig.ts_ls.setup {
      }
      -- lua
      lspconfig.lua_ls.setup {}
      -- python
      lspconfig.pylsp.setup {
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
      -- Rust
      lspconfig.rust_analyzer.setup {
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
      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

          -- Find references for the word under your cursor.
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })
    end
  },
}
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
