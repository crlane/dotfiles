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
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                ruff = {},
              },
            },
          },
        },
        bash_lsp = {},
        zls = {},
      }
      for server, settings in pairs(servers) do
        vim.lsp.config(server, settings)
        vim.lsp.enable(server)
      end
    end,
  },
}
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
