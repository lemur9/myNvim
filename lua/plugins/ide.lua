-- IDE 舒适度插件集：自动配对、注释、环绕编辑、快速跳转、智能折叠。
-- 全部为懒加载的小插件，补齐与 VSCode / JetBrains 接近的日常手感。

LemurVim.plugins.ide = {
  -- 自动配对括号：输入 ( [ { " ' 时自动补全右半部分
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true, -- 结合 treesitter 判断（字符串/注释内不自动配对）
    },
  },

  -- 注释快捷键：
  --   gcc 注释/取消当前行，gc 注释选中区域
  --   gbc 行块注释，gb 选中区域块注释
  {
    "folke/ts-comments.nvim",
    event = "BufReadPost",
    opts = {},
  },

  -- 环绕编辑：
  --   ys<textobj>" 把对象包上引号（如 ysiw"）
  --   cs"' 把双引号换成单引号，ds" 删除引号
  {
    "kylechui/nvim-surround",
    keys = {
      { "ys", desc = "添加环绕" },
      { "yS", desc = "添加环绕（换行）" },
      { "cs", desc = "替换环绕" },
      { "ds", desc = "删除环绕" },
      { "S", mode = "x", desc = "环绕选中文本" },
      { "gS", mode = "x", desc = "环绕选中文本（换行）" },
    },
    opts = {},
  },

  -- 快速跳转：按 s 再输入两个字符即可跳到屏幕内任意位置（EasyMotion 风格）
  {
    "folke/flash.nvim",
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash 快速跳转" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter 跳转" },
    },
    opts = {},
  },

  -- 智能折叠：优先用 treesitter（比缩进折叠精准），zo/zo/zc 用法不变
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "BufReadPost",
    config = function()
      vim.o.foldcolumn = "1" -- 左侧显示折叠列
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      require("ufo").setup({
        provider_selector = function()
          return { "treesitter", "indent" }
        end,
      })
    end,
  },
}
