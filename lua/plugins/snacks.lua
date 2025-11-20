LemurVim.plugins.snacks = {
  "folke/snacks.nvim",
  lazy = true, -- 延迟加载
  opts = {
    lsp = { code_actions = true },  -- 启用 code action 灯泡
    notifier = { enabled = true },  -- 启用通知系统
    picker = { files = true },      -- 启用文件搜索功能
  },
  keys = {
    -- 快捷键示例
    { "<leader>ca", function() require("snacks").lsp.code_actions() end, desc = "Code Actions" },
    { "<leader>nf", function() require("snacks").picker.files() end, desc = "Find Files" },
    { "<leader>nh", function() require("snacks").notifier.show_history() end, desc = "Notification History" },
  },
}

