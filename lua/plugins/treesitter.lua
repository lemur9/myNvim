return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = "BufReadPost",
        config = function()
            -- 保存自动格式化
            local auto_indent = vim.api.nvim_create_augroup("AUTO_INDENT", {clear = true})
            vim.api.nvim_create_autocmd({"BufWritePost"}, {
                pattern = "*",
                group = auto_indent,
                command = 'normal! gg=G``'
            })
            require("nvim-treesitter.configs").setup({
                -- one of "all"
                ensure_installed = {
                    "c",
                    "javascript",
                    "css",
                    "scss",
                    "typescript",
                    "tsx",
                    "json",
                    "vue",
                    "python",
                    "html",
                    "lua",
                    "svelte",
                    "vim",
                    "java",
                    "astro",
                    "markdown",
                    "markdown_inline",
                    "bash",
                    "fish",
                    "prisma",
                    "regex",
                },
                sync_install = true,
                ignore_install = { "php", "phpdoc" },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = {
                    enable = true,
                },
                context_commentstring = {
                    enable = true,
                    enable_autocmd = false,
                },
                rainbow = {
                    enable = true,
                    -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
                    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
                    max_file_lines = nil, -- Do not enable for files with more than n lines, int
                    -- colors = {}, -- table of hex strings
                    -- termcolors = {} -- table of colour name strings
                },
            })
        end,
    },
}
