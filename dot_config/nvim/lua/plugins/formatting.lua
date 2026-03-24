return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format({ async = true })
        end,
        mode = '',
        desc = 'Conform: Format buffer',
      },
    },
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' },
        javascript = { 'eslint', 'prettier' },
        typescript = { 'eslint', 'prettier' },
        json = { 'prettier' },
        rust = { 'rustfmt' },
        go = { 'gofmt' },
        xml = { 'xmllint' },
      },
      default_format_opts = {
        lsp_format = 'fallback',
      },
      format_on_save = { timeout_ms = 500 },
      formatters = {
        shfmt = {
          prepend_args = { '-i', '2' },
        },
        stylua = {},
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
}
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
