-- Lua 片段
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  -- 局部函数
  s("lfun", {
    t("local function "),
    i(1, "name"),
    t("("),
    i(2, "args"),
    t({ ")", "\t" }),
    i(0),
    t({ "", "end" }),
  }),

  -- print 调试
  s("pdb", {
    t("print("),
    i(1, '"msg"'),
    t(")"),
  }),

  -- pcall 保护调用
  s("pcall", {
    t("local ok, result = pcall("),
    i(1, "函数"),
    t({ ")", "", "if not ok then", "\t" }),
    i(0),
    t({ "", "end" }),
  }),

  -- 模块模板
  s("module", {
    t({ "local M = {}", "", "" }),
    i(0),
    t({ "", "return M" }),
  }),
}
