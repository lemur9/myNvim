-- 代码片段：LuaSnip + friendly-snippets + 自定义片段
-- 1. LuaSnip 作为片段引擎，blink.cmp 通过 preset = "luasnip" 使用它
-- 2. friendly-snippets 提供大量现成片段（VSCode 格式）
-- 3. lua/snippets/ 下的自定义片段（Lua 格式），文件名即 filetype，all.lua 全局生效
LemurVim.plugins["snippets"] = {
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    -- jsregexp 是可选依赖（仅用于正则触发器），不构建也完全可用
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          -- 加载 friendly-snippets 自带片段
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    config = function(_, opts)
      require("luasnip").config.set_config(opts)

      -- 加载自定义片段（lua/snippets/*.lua）
      require("luasnip.loaders.from_lua").lazy_load({
        paths = { vim.fn.stdpath("config") .. "/lua/snippets" },
      })

      -- 让 <Tab> 在片段占位符之间跳转（覆盖原生 vim.snippet 实现）
      LemurVim.cmp.actions.snippet_forward = function()
        if require("luasnip").jumpable(1) then
          vim.schedule(function()
            require("luasnip").jump(1)
          end)
          return true
        end
      end
      LemurVim.cmp.actions.snippet_stop = function()
        if require("luasnip").expand_or_jumpable() then
          require("luasnip").unlink_current()
          return true
        end
      end
    end,
  },
}
