-- 文件状态展示插件
LemurVim.plugins.lualine = {
    {
        'nvim-lualine/lualine.nvim',
        event = 'VeryLazy',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = function()
            local icons = LemurVim.config.icons.diagnostic_icons
            return {
                options = {
                    theme = 'tokyonight-night',
                    component_separators = { right = '|' },
                    section_separators = '',
                },
                sections = {
                    lualine_b = {
                        'branch',
                        'diff',
                        {
                            'diagnostics',
                            symbols = icons,
                        },
                    },
                },
            }
        end,
    }
}
