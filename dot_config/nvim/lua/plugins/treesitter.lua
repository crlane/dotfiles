return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        opts = {
            highlight = {
                enable = true,
                disable = { 'python', 'go', 'lua' },
            },
            ensure_installed = {
                'go',
                'lua',
                'python',
                'rust',
                'zig',
                -- shells
                'bash',
                -- config langs
                'json',
                'json5',
                'yaml',
                'toml',
                'ini',
                'csv',
                'tsv',
                -- doc langs
                'latex',
                'bibtex',
                'rst',
                'markdown',
                'markdown_inline',
                -- git
                'git_config',
                'git_rebase',
                'gitattributes',
                'gitcommit',
                'gitignore',
            },
        },
        config = function(_, opts)
            require('nvim-treesitter.configs').setup(opts)
        end,
        opts_extend = { 'ensure_installed' },
    },
}
