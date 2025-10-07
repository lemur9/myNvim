-- 文件树插件
return {
    {
        'nvim-tree/nvim-tree.lua',
        cmd = 'NvimTreeToggle',
        version = '*',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            local icons = require('plugins.config.icons').diagnostic_icons

            require('nvim-tree').setup({
                update_cwd = true,
                respect_buf_cwd = true,
                update_focused_file = {
                    enable = true,
                    update_cwd = true,
                },
                view = {
                    width = 30,
                    side = 'left',
                },
                renderer = {
                    indent_markers = {
                        enable = true,
                        icons = {
                            corner = '└',
                            edge = '│',
                            item = '│',
                            bottom = '─',
                            none = ' ',
                        },
                    },
                    icons = {
                        webdev_colors = true,
                        git_placement = 'before',
                        glyphs = {
                            default = '',
                            symlink = '',
                            git = {
                                unstaged = '',
                                staged = '',
                                unmerged = '',
                                renamed = '﯀',
                                deleted = '',
                                untracked = '󱧈',
                                ignored = '',
                            },
                            folder = {
                                default = '',
                                open = '',
                                empty = '',
                                empty_open = '',
                                symlink = '',
                            },
                        },
                    },
                },
                diagnostics = {
                    enable = true,
                    show_on_dirs = true,
                    icons = {
                        error = icons.error,
                        warning = icons.warn,
                        hint = icons.hint,
                        info = icons.info,
                    },
                },
                actions = {
                    change_dir = {
                        enable = true,
                        global = false,
                        restrict_above_cwd = false,
                    },
                    open_file = {
                        quit_on_open = true,
                        resize_window = true,
                        window_picker = {
                            enable = true,
                            chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890',
                            exclude = {
                                filetype = { 'notify', 'packer', 'qf', 'diff', 'fugitive', 'fugitiveblame' },
                                buftype = { 'nofile', 'terminal', 'help' },
                            },
                        },
                    },
                },
            })
 
        end,
    },
}

