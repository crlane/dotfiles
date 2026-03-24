return {
  {
    'edkolev/tmuxline.vim',
    config = function() end,
  },
  {
    'itchyny/lightline.vim',
    lazy = false,
    config = function()
      vim.o.showmode = false
      vim.g.lightline = {
        colorscheme = 'one',
        active = {
          left = {
            { 'mode', 'paste' },
            { 'readonly', 'filename', 'modified' },
          },
          right = {
            { 'lineinfo' },
            { 'percent' },
            { 'fileencoding', 'filetype' },
          },
        },
        component_function = {
          filename = 'LightlineFilename',
        },
      }
      function LightlineFilenameInLua(_)
        if vim.fn.expand('%:t') == '' then
          return '[No Name]'
        else
          return vim.fn.getreg('%')
        end
      end

      vim.api.nvim_exec(
        [[
                function! g:LightlineFilename()
                    return v:lua.LightlineFilenameInLua()
                endfunction
                ]],
        true
      )
    end,
  },
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
}
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
