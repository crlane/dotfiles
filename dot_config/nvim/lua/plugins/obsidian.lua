local workspaces = function()
  local paths = {
    work = vim.fn.expand('~') .. '/vaults/work',
    personal = vim.fn.expand('~') .. '/Library/Mobile Documents/iCloud~md~obsidian/Documents/Personal',
  }

  local existingPaths = {}
  for wsName, wsPath in pairs(paths) do
    if vim.uv.fs_stat(wsPath) then
      table.insert(existingPaths, { name = wsName, path = wsPath })
    end
  end

  return existingPaths
end

return {

  'obsidian-nvim/obsidian.nvim',
  version = '*', -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = 'markdown',
  dependencies = {
    -- Required.
    'nvim-lua/plenary.nvim',
  },
  opts = {
    workspaces = workspaces(),
    completion = {
      nvim_cmp = false,
      blink = true,
    },
    daily_notes = {
      folder = 'dailies',
      date_format = 'YYYY/MM-MMMM/YYYY-MM-DD-dddd',
      alias_format = '%B %-d, %Y',
      -- Optional, default tags to add to each new daily note created.
      default_tags = { 'daily' },
      -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
      -- template = 'crlane-daily',
    },
    preferred_link_style = 'markdown',
    disable_frontmatter = false,
    -- Optional, for templates (see below).
    templates = {
      folder = vim.fn.expand('~') .. '/.config/obsidian/templates',
      date_format = '%Y-%m-%d',
      time_format = '%H:%M',
      -- A map for custom variables, the key should be the variable and the value a function
      substitutions = {},
    },
    ui = { enable = false },
  },
  vim.keymap.set(
    { 'n', 'v' },
    '<leader>so',
    '<cmd>ObsidianSearch<cr>',
    { noremap = true, desc = '[S]earch [O]bsidian' }
  ),
  vim.keymap.set({ 'n', 'v' }, '<leader>on', '<cmd>ObsidianNew<cr>', { desc = '[O]bsidian [N]ew', buffer = true }),
  vim.keymap.set({ 'n', 'v' }, '<leader>ont', '<cmd>ObsidianNewFromTemplate<cr>', { desc = '[S]earch [O]bsidian' }),
  vim.keymap.set({ 'v' }, '<leader>ox', '<cmd>ObsidianExtractNote<cr>', { desc = '[O]bsidian E[x]tract note' }),
  vim.keymap.set({ 'n' }, '<leader>oy', '<cmd>ObsidianYesterday<cr>', { desc = '[O]bsidian [Y]esterday' }),
  vim.keymap.set({ 'n' }, '<leader>od', '<cmd>ObsidianDailies<cr>', { desc = '[O]bsidian [D]ailies' }),
  vim.keymap.set({ 'n' }, '<leader>ot', '<cmd>ObsidianToday<cr>', { desc = '[O]bsidian [T]oday' }),
  vim.keymap.set({ 'n' }, '<leader>ow', '<cmd>ObsidianTomorrow<cr>', { desc = '[O]bsidian Tomorro[w]' }),
  vim.keymap.set({ 'n' }, '<leader>og', '<cmd>ObsidianTags<cr>', { desc = '[O]bsidian Ta[g]s' }),
  vim.keymap.set({ 'n' }, '<leader>oq', '<cmd>ObsidianQuickSwitch<cr>', { desc = '[O]bsidian [Q]uickSwitch' }),
  vim.keymap.set({ 'n' }, '<leader>op', '<cmd>ObsidianWorkspace<cr>', { desc = '[O]bsidian [W]orkspace' }),
  vim.keymap.set({ 'n' }, '<leader>ok', '<cmd>ObsidianToggleCheckbox<cr>', { desc = '[O]bsidian Chec[k]box' }),
}
