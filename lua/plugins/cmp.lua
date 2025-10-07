return {
    -- 提供代码片段支持，能够通过快捷键快速插入预定义的代码片段
    {
        'L3MON4D3/LuaSnip',
        version = 'v2.*',
        build = 'make install_jsregexp',    -- 增强正则支持
        event = 'InsertEnter',
        dependencies = {
            -- 为 nvim-cmp 提供 LuaSnip 的补全支持.
            'saadparwaiz1/cmp_luasnip' ,
            {
                -- 提供一些常见的代码片段。 
                'rafamadriz/friendly-snippets',
                config = function()
                    require('luasnip.loaders.from_vscode').lazy_load()
                    require('luasnip.loaders.from_lua').lazy_load({
                        paths = {
                            vim.fn.stdpath("config") .. "/lua/plugins/config/snippets"
                        }
                    })
                end,
            },
        },
        keys = {
            {
                '<C-j>',
                function()
                    return require('luasnip').jumpable(1) and '<Plug>luasnip-jump-next' or '<space>'
                end,
                expr = true,
                silent = true,
                mode = 'i',
            },
            {
                '<C-j>',
                function()
                    require('luasnip').jump(1)
                end,
                mode = 's',
            },
            {
                '<C-k>',
                function()
                    require('luasnip').jump(-1)
                end,
                mode = { 'i', 's' },
            },
        },
    },

    -- 自动补全
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',         -- LSP 补全
            'hrsh7th/cmp-path',             -- 文件路径补全
            'hrsh7th/cmp-buffer',           -- 当前缓冲区内容补全
            'hrsh7th/cmp-cmdline',          -- 命令行补全
            'onsails/lspkind.nvim',         -- 美化补全图标
            {
                'Exafunction/codeium.nvim',
                config = function()
                    require('codeium').setup({
                        on_error = function()
                            vim.notify("codeium network err");
                        end  -- 空函数
                    })
                end,
            },
        },
        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')
            local lspkind = require('lspkind')

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                sources = {
                    { name = 'codeium',     priority = 100 },
                    { name = 'nvim_lsp',    priority = 90 },
                    { name = 'luasnip',     priority = 80 },
                    { name = 'buffer',      priority = 70 },
                    { name = 'treesitter',  priority = 60 },
                    { name = 'path',        priority = 50 },
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                formatting = {
                    format = lspkind.cmp_format({
                        mode = 'symbol',
                        maxwidth = 50,
                        ellipsis_char = '...',
                        show_labelDetails = true,
                        symbol_map = { Codeium = '' },
                    }),
                    fields = { 'abbr', 'kind', 'menu' },
                    expandable_indicator = true,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ['<C-l>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),
                }),
            })

            cmp.setup.cmdline({ '/', '?' }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' },
                },
            })

            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' },
                    { name = 'cmdline' },
                }),
            })
        end,
    },
}
