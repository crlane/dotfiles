return {
  -- zig
  {
    'ziglang/zig',
    ft = { 'zig' },
  },
  -- terraform
  {
    'hashivim/vim-terraform',
    ft = { 'terraform' },
  },
  -- svelte
  {
    'evanleck/vim-svelte',
    ft = { 'svelte' },
  },
  -- toml
  'cespare/vim-toml',
  -- jinja
  'lepture/vim-jinja',
  -- yaml
  {
    'cuducos/yaml.nvim',
    ft = { 'yaml' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
  },
  -- rust
  {
    'rust-lang/rust.vim',
    ft = { 'rust' },
    config = function()
      vim.g.rustfmt_autosave = 1
      vim.g.rustfmt_emit_files = 1
      vim.g.rustfmt_fail_silently = 0
      vim.g.rust_clip_command = 'wl-copy'
    end,
  },
  {
    'ray-x/go.nvim',
    dependencies = { -- optional packages
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('go').setup()
    end,
    event = { 'CmdlineEnter' },
    ft = { 'go', 'gomod' },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
}
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
