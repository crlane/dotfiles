return {
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
}
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
