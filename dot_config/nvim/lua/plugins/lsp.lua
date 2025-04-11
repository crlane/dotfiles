-- LSP configs
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Allows extra capabilities provided by blink.cmp
      "saghen/blink.cmp",
    },
    config = function()
      -- Setup language servers.
      local lspconfig = require("lspconfig")
      -- typescript
      lspconfig.ts_ls.setup({})
      -- lua
      lspconfig.lua_ls.setup {}
      -- python
      lspconfig.pylsp.setup({
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
          },
        },
      })
      -- Rust
      lspconfig.rust_analyzer.setup({
        -- Server-specific settings. See `:help lspconfig-setup`
        settings = {
          ["rust-analyzer"] = {
            cargo = {},
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
      })

      -- Bash LSP
      local configs = require("lspconfig.configs")
      if not configs.bash_lsp and vim.fn.executable("bash-language-server") == 1 then
        configs.bash_lsp = {
          default_config = {
            cmd = { "bash-language-server", "start" },
            filetypes = { "sh" },
            root_dir = lspconfig.util.find_git_ancestor,
            init_options = {
              settings = {
                args = {},
              },
            },
          },
        }
      end

      -- Zig
      -- don't show parse errors in a separate window
      vim.g.zig_fmt_parse_errors = 0
      -- disable format-on-save from `ziglang/zig.vim`
      vim.g.zig_fmt_autosave = 0
      lspconfig.zls.setup({})
      -- eslint
      lspconfig.eslint.setup({
        flags = {
          allow_incremental_sync = false,
          debounce_text_changes = 1000,
        },
      })
    end,
  },
}
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
