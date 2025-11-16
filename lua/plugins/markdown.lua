LemurVim.plugins.markdown = {
    {
        'iamcco/markdown-preview.nvim',
        ft = { 'markdown' },
        build = "cd app && yarn install",
        keys = {
            { "<leader>mk", "<cmd>MarkdownPreviewToggle<cr>", desc = "Toggle Markdown Preview" },
        },
        config = function ()
            LemurVim.G.g.mkdp_auto_start = 1
            LemurVim.G.g.mkdp_auto_close = 1
            LemurVim.G.g.mkdp_echo_preview_url = 1
            LemurVim.G.g.mkdp_markdown_css = os.getenv('HOME') .. '/.config/nvim/lua/plugins/config/css/markdown.css'
            LemurVim.G.g.mkdp_highlight_css = os.getenv('HOME') .. '/.config/nvim/lua/plugins/config/css/highlight.css'
            LemurVim.G.g.mkdp_browser = 'microsoft-edge-beta'
            LemurVim.G.g.mkdp_theme = 'light'
        end
    },
    {
        'dhruvasagar/vim-table-mode',
        ft = 'markdown',
    },
    {
        'ferrine/md-img-paste.vim',
        ft = 'markdown',
    },

}
