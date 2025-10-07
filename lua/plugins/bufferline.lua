return {
    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = {"nvim-tree/nvim-web-devicons"},
        config = function()
            -- calling `setup` is optional for customization
            require("bufferline").setup{
                options = {
                    indicator = {
                        icon = '▎', -- 分割线
                        style = 'underline',
                    },
                    buffer_close_icon = '󰅖',
                    modified_icon = '●',
                    close_icon = '',

                    -- 左侧让出 nvim-tree 的位置
                    offsets = {{
                        filetype = "NvimTree",
                        text = "File Explorer",
                        highlight = "Directory",
                        text_align = "left",
                        separator = true,
                    },
                        {
                            filetype = 'vista',
                            text = function()
                                return vim.fn.getcwd()
                            end,
                            highlight = "Tags",
                            text_align = "right"
                        }

                    }
                }
            }
        end
    }
}

