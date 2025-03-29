-- main color scheme
return {
    {
       "tiagovla/tokyodark.nvim",
        lazy = false,
        opts = {
            -- custom options here
        },
        config = function(_, opts)
            require("tokyodark").setup(opts) -- calling setup is optional
            vim.cmd [[colorscheme tokyodark]]
        end,
    },
    {
       "navarasu/onedark.nvim",
    },
    {
        'maxmx03/solarized.nvim',
        lazy = false,
        priority = 1000,
        config = function()
          vim.o.background = 'dark' -- or 'light'

          vim.cmd.colorscheme 'solarized'
        end,
    },
}
