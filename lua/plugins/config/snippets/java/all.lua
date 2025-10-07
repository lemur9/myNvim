local ls = require("luasnip")
local t = ls.text_node        -- 定义文本节点
local i = ls.insert_node      -- 定义插入节点

return {
    ls.snippet("psvf", {
        t({"public static void "}),
        i(1, "functionName"),
        t({"("}),
        i(2, "Object"),
        t({" "}),
        i(3, "args"),
        t({") {", "\t"}),
        i(0),
        t({"", "}"})
    }, {
            docstring = "Generate main method",
            condition = function()
                return vim.bo.filetype == "java"
            end
        }
    ),

}
