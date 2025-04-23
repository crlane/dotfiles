-- LSP configs
return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Allos extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      -- Setup language servers.
      local servers = {
        ts_ls = {},
        lua_ls = {},
        rust_analyzer = {},
        basedpyright = {
          settings = {
            basedpyright = {
              disableOrganizeImports = true,
            },
          },
        },
        ruff = {}, -- use pyproject.toml for per project settings
        bashls = {},
        zls = {},
        gopls = {},
      }
      for server, settings in pairs(servers) do
        vim.lsp.config(server, settings)
        vim.lsp.enable(server)
      end
    end,
  },
  vim.diagnostic.config({
    -- Use the default configuration
    -- virtual_lines = true,

    -- Alternatively, customize specific options
    virtual_lines = {
      -- Only show virtual line diagnostics for the current cursor line
      current_line = true,
    },
  }),
}
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
