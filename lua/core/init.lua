local M = {}

LemurVim.config = M
LemurVim.version = "1.0.0"

local defaults = {
  icons = LemurVim.icons
}

local options

function M.setup(opts)
  options = vim.tbl_deep_extend("force", defaults, opts or {}) or {}
end

setmetatable(M, {
  __index = function(_, key)
    if options == nil then
      return vim.deepcopy(defaults)[key]
    end
    return options[key]
  end,
})

require("core.options") -- 基础配置
require("core.keymaps") -- 按键配置
require("core.autocmd") -- 自动命令配置

return M
