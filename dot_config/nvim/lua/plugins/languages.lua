return {
    -- language support
    -- zig
    {
      'ziglang/zig',
      ft = {"zig"}
    },
    -- terraform
    {
        'hashivim/vim-terraform',
        ft = { "terraform" },
    },
    -- svelte
    {
        'evanleck/vim-svelte',
        ft = { "svelte" },
    },
    -- toml
    'cespare/vim-toml',
    -- jinja
    'lepture/vim-jinja',
    -- yaml
    {
        "cuducos/yaml.nvim",
        ft = { "yaml" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
    },
    -- rust
    {
        'rust-lang/rust.vim',
        ft = { "rust" },
        config = function()
            vim.g.rustfmt_autosave = 1
            vim.g.rustfmt_emit_files = 1
            vim.g.rustfmt_fail_silently = 0
            vim.g.rust_clip_command = 'wl-copy'
        end
    },
    -- markdown
    {
        'plasticboy/vim-markdown',
        ft = { "markdown" },
        dependencies = {
            'godlygeek/tabular',
        },
        config = function()
            -- never ever fold!
            vim.g.vim_markdown_folding_disabled = 1
            -- support front-matter in .md files
            vim.g.vim_markdown_frontmatter = 1
            -- 'o' on a list item should insert at same level
            vim.g.vim_markdown_new_list_item_indent = 0
            -- don't add bullets when wrapping:
            -- https://github.com/preservim/vim-markdown/issues/232
            vim.g.vim_markdown_auto_insert_bullets = 0
        end
    },
    {
        'ray-x/go.nvim',
        dependencies = {  -- optional packages
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
          },
          config = function()
            require("go").setup()
          end,
          event = {"CmdlineEnter"},
          ft = {"go", 'gomod'},
          build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
    },
}
