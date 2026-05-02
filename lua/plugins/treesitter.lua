LemurVim.plugins["nvim-treesitter"] = {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
        lazy = false,
        config = function()
            local parsers = {
                "c", "javascript", "css", "scss", "typescript", "tsx",
                "json", "vue", "python", "html", "lua", "svelte", "vim",
                "java", "astro", "markdown", "markdown_inline", "bash",
                "fish", "prisma", "regex",
            }
            require("nvim-treesitter").install(parsers)

            -- 启用原生 treesitter 高亮（Neovim 0.12 内置）
            vim.api.nvim_create_autocmd("FileType", {
                callback = function(ev)
                    pcall(vim.treesitter.start, ev.buf)
                end,
            })
        end,
    },
}
