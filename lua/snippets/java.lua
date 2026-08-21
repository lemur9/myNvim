-- Java 片段
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  -- main 方法
  s("main", {
    t({ "public static void main(String[] args) {", "\t" }),
    i(0),
    t({ "", "}" }),
  }),

  -- 标准输出
  s("sout", {
    t("System.out.println("),
    i(1, '""'),
    t(");"),
  }),

  -- 普通 for 循环
  s("fori", {
    t("for (int "),
    i(1, "i"),
    t(" = 0; "),
    i(2, "i"),
    t(" < "),
    i(3, "n"),
    t("; "),
    i(4, "i"),
    t({ "++) {", "\t" }),
    i(0),
    t({ "", "}" }),
  }),

  -- 增强 for 循环
  s("foreach", {
    t("for ("),
    i(1, "类型"),
    t(" "),
    i(2, "元素"),
    t(" : "),
    i(3, "集合"),
    t({ ") {", "\t" }),
    i(0),
    t({ "", "}" }),
  }),

  -- try-catch
  s("try", {
    t({ "try {", "\t" }),
    i(0),
    t({ "", "} catch (Exception e) {", "\te.printStackTrace();", "}" }),
  }),
}
