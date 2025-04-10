-- main color scheme
return {
  {
    "tiagovla/tokyodark.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- custom options here
    },
    config = function(_, opts)
      require("tokyodark").setup(opts) -- calling setup is optional
      vim.cmd [[colorscheme tokyodark]]
    end,
  },
  "navarasu/onedark.nvim",
}
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
