return {
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      local actions = require('telescope.actions')
      require('telescope').setup({
        pickers = { colorscheme = { enable_preview = true } },
        defaults = {
          path_display = { 'smart' },
          mappings = {
            i = {
              ['<C-h>'] = actions.select_horizontal,
            },
          },
        },
      })
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[S]earch [B]uffers' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s,', builtin.oldfiles, { desc = '[S]earch Recent Files' })
      vim.keymap.set('n', '<leader>s.', function()
        builtin.find_files({ cwd = vim.fn.expand('%:p:h') })
      end, { desc = '[S]earch Files in [.]' })
      vim.keymap.set('n', '<leader>sa', function()
        builtin.find_files({
          find_command = { 'rg', '--files', '--no-ignore-vcs' },
          prompt_title = 'Find Files (include .gitignored)',
        })
      end, { desc = '[S]earch [A]ll Files including .gitignored.' })
      vim.keymap.set('n', '<leader>se', function()
        builtin.find_files({
          find_command = { 'rg', '--files', '--no-ignore-vcs', '--hidden', '--glob', '!**/.git/*' },
          prompt_title = 'Find Files (Everything)',
        })
      end, { desc = '[S]earch [E]verything, including hidden and ignored!' })

      vim.keymap.set('n', '<leader>uc', builtin.colorscheme, { desc = '[U]I colorscheme preview' })
    end,
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    keys = {
      { '<leader>ft', '<cmd>Neotree toggle<cr>', desc = 'NeoTree' },
    },
    opts = {},
  },
}
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
