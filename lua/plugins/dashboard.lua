LemurVim.plugins.dashboard = {
    "nvimdev/dashboard-nvim",
    event = "User IceAfter colorscheme",
    opts = {
        theme = "doom",
        config = {
            -- https://patorjk.com/software/taag/#p=display&f=ANSI%20Shadow&t=icenvim
            header = {
                " ",
                "██╗     ███████╗███╗   ███╗██╗   ██╗██████╗ ███╗   ██╗██╗   ██╗██╗███╗   ███╗",
                "██║     ██╔════╝████╗ ████║██║   ██║██╔══██╗████╗  ██║██║   ██║██║████╗ ████║",
                "██║     █████╗  ██╔████╔██║██║   ██║██████╔╝██╔██╗ ██║██║   ██║██║██╔████╔██║",
                "██║     ██╔══╝  ██║╚██╔╝██║██║   ██║██╔══██╗██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
                "███████╗███████╗██║ ╚═╝ ██║╚██████╔╝██║  ██║██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
                "╚══════╝╚══════╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
                " ",
                string.format("                      %s                       ", LemurVim.version),
                " ",
            },
            center = {
                {
                    icon = "  ",
                    desc = "Lazy Profile",
                    action = "Lazy profile",
                },
                {
                    icon = "  ",
                    desc = "Edit preferences   ",
                    action = string.format("edit ~/.config/nvim/init.lua"),
                },
                {
                    icon = "  ",
                    desc = "Mason",
                    action = "Mason",
                },
                {
                    icon = "  ",
                    desc = "About LemurVim",
                    action = "LemurAbout",
                },
            },
            footer = { "🧊 Hope that you enjoy using LemurNvim 😀😀😀" },
        },
    },
    config = function(_, opts)
        require("dashboard").setup(opts)

        if vim.api.nvim_buf_get_name(0) == "" then
            vim.cmd "Dashboard"
        end

        -- Use the highlight command to replace instead of overriding the original highlight group
        -- Much more convenient than using vim.api.nvim_set_hl()
        vim.cmd "highlight DashboardFooter cterm=NONE gui=NONE"
    end,
}
