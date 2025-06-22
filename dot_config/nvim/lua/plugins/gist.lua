return {
    {
        'Rawnly/gist.nvim',
        cmd = { 'GistCreate', 'GistCreateFromFile', 'GistsList' },
        config = function()
            require('gist').setup({
                gh_cmd = 'op plugin run -- gh',
            })
        end,
    },
    -- `GistsList` opens the selected gist in a terminal buffer,
    -- nvim-unception uses neovim remote rpc functionality to open the gist in an actual buffer
    -- and prevents neovim buffer inception
    {
        'samjwill/nvim-unception',
        lazy = false,
        init = function()
            vim.g.unception_block_while_host_edits = true
            vim.g.unception_open_buffer_in_new_tab = true
        end,
    },
}
