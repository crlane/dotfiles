-- Enable LSP servers (configs live in lsp/*.lua)
vim.lsp.enable({
  'ts_ls',
  'lua_ls',
  'rust_analyzer',
  'basedpyright',
  'ty',
  'ruff',
  'bashls',
  'zls',
  'gopls',
})

vim.diagnostic.config({
  virtual_lines = {
    current_line = true,
  },
})

return {}
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
