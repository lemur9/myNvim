-- 全局片段（所有文件类型可用）
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local f = ls.function_node

return {
  -- 当前日期 YYYY-MM-DD
  s("date", { f(function()
    return os.date("%Y-%m-%d")
  end) }),

  -- 当前时间 HH:MM:SS
  s("time", { f(function()
    return os.date("%H:%M:%S")
  end) }),

  -- 截止日期（配合 Markdown 待办系统高亮）
  s("deadline", { t("D:"), f(function()
    return os.date("%Y-%m-%d")
  end) }),

  -- 开始日期（配合 Markdown 待办系统高亮）
  s("startdate", { t("S:"), f(function()
    return os.date("%Y-%m-%d")
  end) }),
}
