local M = {}

LemurVim.config = M
LemurVim.version = "1.0.0"

local defaults = {
  icons = LemurVim.icons,
}

setmetatable(M, {
  __index = function(_, key)
    return defaults[key]
  end,
})

require("core.options") -- 基础配置
require("core.keymaps") -- 按键配置
require("core.autocmd") -- 自动命令配置

return M
