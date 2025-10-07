local ls = require("luasnip")  -- 引用 LuaSnip 模块
local s = ls.snippet          -- 定义 snippet
local t = ls.text_node        -- 定义文本节点
local i = ls.insert_node      -- 定义插入节点
local c = ls.choice_node      -- 定义选择节点
local f = ls.function_node    -- 定义函数节点

return {
    -- 简单文本片段
    ls.snippet("trigger", {
        t("Hello LuaSnip!")
    }),

    -- 带占位符的片段
    ls.snippet("fn", {
        t({"function()", "\t"}),
        i(1, "content"),
        t({"", "end"})
    }),

    -- 使用动态生成的片段
    ls.snippet("date", {
        f(function() return os.date("%Y-%m-%d") end)
    }),

    s("choose", {
        t("Choose: "),
        c(1, { t("Option 1"), t("Option 2"), t("Option 3") }),  -- 选择节点
        t(" done.")
    })

}
