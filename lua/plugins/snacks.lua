LemurVim.plugins["snacks"] = {
  "folke/snacks.nvim",
  lazy = true, -- 延迟加载
  opts = {
    lsp = { code_actions = true },  -- 启用 code action 灯泡
    notifier = { enabled = true },  -- 启用通知系统
    picker = { files = true },      -- 启用文件搜索功能
  },

}

