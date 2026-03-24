return {
  {
    'numToStr/Comment.nvim',
    opts = {},
  },
  {
    'andymass/vim-matchup',
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = 'popup' }
    end,
  },
  {
    'kylechui/nvim-surround',
    version = '^3.0.0',
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup({})
    end,
  },
  {
    'echasnovski/mini.align',
    version = '*',
    config = function()
      require('mini.align').setup({})
    end,
  },
  {
    'andrewferrier/wrapping.nvim',
    config = function()
      require('wrapping').setup({
        softener = { markdown = true, rst = true },
      })
    end,
  },
  { 'tris203/precognition.nvim', opts = {} },
}
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
