LemurVim.plugins.snacks = {
  "folke/snacks.nvim",
  lazy = true, -- 延迟加载
  opts = {
    lsp = { code_actions = true },
    notifier = { enabled = true },
    picker = { files = true },
    rename = { enabled = true },
  },
  keys = {
    -- 快捷键示例
    { "<leader>ca", function() require("snacks").lsp.code_actions() end, desc = "代码操作" },
    { "<leader>nf", function() require("snacks").picker.files() end, desc = "查找文件" },
    { "<leader>nh", function() require("snacks").notifier.show_history() end, desc = "通知历史" },
  },
}

