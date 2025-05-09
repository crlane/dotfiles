-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out,                            'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require('lazy').setup({
  spec = {
    -- import your plugins
    { import = 'plugins' },
    -- Git support
    {
      'tpope/vim-fugitive',
      cmd = 'Git',
    },
    {
      'airblade/vim-gitgutter',
    },
    {
      'numToStr/Comment.nvim',
      opts = {
        -- add any options here
      },
    },
    -- nice bar at the bottom
    {
      'edkolev/tmuxline.vim',
      config = function() end,
    },
    -- nice bar at the bottom
    {
      'itchyny/lightline.vim',
      lazy = false, -- also load at start since it's UI
      config = function()
        -- no need to also show mode in cmd line when we have bar
        vim.o.showmode = false
        vim.g.lightline = {
          colorscheme = 'one',
          active = {
            left = {
              { 'mode',     'paste' },
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

        -- https://github.com/itchyny/lightline.vim/issues/657
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
    -- better %
    {
      'andymass/vim-matchup',
      config = function()
        vim.g.matchup_matchparen_offscreen = { method = 'popup' }
      end,
    },
    -- auto-cd to root of git project
    {
      'notjedi/nvim-rooter.lua',
      config = function()
        require('nvim-rooter').setup({
          rooter_patterns = { '.git', '.obsidian' },
          trigger_patterns = { '*' },
          manual = false,
          fallback_to_parent = false,
          cd_scope = 'smart',
        })
      end,
    },
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
            mappings = {
              i = {
                ['<C-h>'] = actions.select_horizontal,
              },
            },
          },
        })
        -- See `:help telescope.builtin`
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
      'andrewferrier/wrapping.nvim',
      config = function()
        require('wrapping').setup({
          softener = { markdown = true, rst = true },
        })
      end,
    },
    {
      'stevearc/conform.nvim',
      event = { 'BufWritePre' },
      cmd = { 'ConformInfo' },
      keys = {
        {
          -- Customize or remove this keymap to your liking
          '<leader>f',
          function()
            require('conform').format({ async = true })
          end,
          mode = '',
          desc = 'Conform: Format buffer',
        },
      },
      -- This will provide type hinting with LuaLS
      ---@module "conform"
      ---@type conform.setupOpts
      opts = {
        -- Define your formatters
        formatters_by_ft = {
          lua = { 'stylua' },
          python = { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' },
          javascript = { 'eslint', 'prettier' },
          typescript = { 'eslint', 'prettier' },
          rust = { 'rustfmt' },
          go = { 'gofmt' },
          xml = { 'xmllint' },
        },
        -- Set default options
        default_format_opts = {
          lsp_format = 'fallback',
        },
        -- Set up format-on-save
        format_on_save = { timeout_ms = 500 },
        -- Customize formatters
        formatters = {
          shfmt = {
            prepend_args = { '-i', '2' },
          },
          stylua = {},
        },
      },
      init = function()
        -- If you want the formatexpr, here is the place to set it
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      end,
    },
    {
      'kylechui/nvim-surround',
      version = '^3.0.0', -- Use for stability; omit to use `main` branch for the latest features
      event = 'VeryLazy',
      config = function()
        require('nvim-surround').setup({
          -- Configuration here, or leave empty to use defaults
        })
      end,
    },
    { -- Highlight todo, notes, etc in comments
      'folke/todo-comments.nvim',
      event = 'VimEnter',
      dependencies = { 'nvim-lua/plenary.nvim' },
      opts = { signs = false },
    },
    -- Example for neo-tree.nvim
    {
      'nvim-neo-tree/neo-tree.nvim',
      keys = {
        { '<leader>ft', '<cmd>Neotree toggle<cr>', desc = 'NeoTree' },
      },
      opts = {},
    },
    {
      'echasnovski/mini.align',
      version = '*',
      config = function()
        require('mini.align').setup({})
      end,
    },
    { 'tris203/precognition.nvim', opts = {} },
  },

  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { 'habamax' } },
  -- automatically check for plugin updates
  checker = {
    -- automatically check for plugin updates
    enabled = false,
    notify = false,        -- get a notification when new updates are found
    frequency = 24 * 3600, -- check for updates every 24 hours at most
  },
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = true,
    notify = true, -- get a notification when changes are found
  },
})
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
