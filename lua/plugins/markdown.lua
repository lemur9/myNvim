local G = require('core.G');

return {
    {
        'iamcco/markdown-preview.nvim',
        ft = { 'markdown' },
        build = "cd app && yarn install",
        keys = {
            { "<leader>mk", "<cmd>MarkdownPreviewToggle<cr>", desc = "Toggle Markdown Preview" },
        },
        config = function ()
            G.g.mkdp_auto_start = 1
            G.g.mkdp_auto_close = 1
            G.g.mkdp_echo_preview_url = 1
            G.g.mkdp_markdown_css = os.getenv('HOME') .. '/.config/nvim/lua/plugins/config/css/markdown.css'
            G.g.mkdp_highlight_css = os.getenv('HOME') .. '/.config/nvim/lua/plugins/config/css/highlight.css'
            G.g.mkdp_browser = 'microsoft-edge-beta'
            G.g.mkdp_theme = 'light'
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
