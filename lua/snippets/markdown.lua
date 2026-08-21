-- Markdown 片段（配合待办系统）
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

return {
  -- 待办事项
  s("todo", {
    t("- [ ] "),
    i(0),
  }),

  -- 已完成事项
  s("done", {
    t("- [x] "),
    i(0),
  }),

  -- 待办 + 截止日期
  s("todod", {
    t("- [ ] "),
    i(1, "待办内容"),
    t("  D:"),
    f(function()
      return os.date("%Y-%m-%d")
    end),
  }),

  -- 代码块
  s("code", {
    t("```"),
    i(1, "语言"),
    t({ "" }),
    i(0),
    t({ "", "```" }),
  }),
}
