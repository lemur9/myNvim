-- 主题插件：从 LemurVim.colorscheme.themes 注册表生成 lazy.nvim spec。
-- 默认主题（lazy=false, priority=1000）在启动时应用；
-- 其余主题按需懒加载，通过 :LemurColorscheme 或 <leader>uC 切换。
local colorscheme = LemurVim.colorscheme

local specs = {}
for name, theme in pairs(colorscheme.themes) do
  local is_default = name == colorscheme.load()

  local spec = {
    theme.repo,
    lazy = not is_default,
  }
  if is_default then
    spec.priority = 1000
    spec.config = function()
      -- 应用默认主题（setup + colorscheme + 触发 LemurAfter colorscheme 事件）
      colorscheme.set(name)
    end
  end

  specs[#specs + 1] = spec
end

LemurVim.plugins["theme"] = specs

-- 主题选择命令
vim.api.nvim_create_user_command("LemurColorscheme", function()
  LemurVim.colorscheme.select()
end, { desc = "选择配色方案" })
