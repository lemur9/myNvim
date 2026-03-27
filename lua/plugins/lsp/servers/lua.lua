local M = {}

--- 获取 lua_ls 配置
function M.get_config()
  return {
    settings = {
      Lua = {
        runtime = {
          -- 告诉语言服务器你在用的是 LuaJIT（Neovim 内置 Lua 版本）
          version = 'LuaJIT',
        },
        diagnostics = {
          -- 让 LSP 识别 Neovim 的全局变量
          globals = { 'vim' },
        },
        workspace = {
          -- 让 LSP 知道 Neovim 的运行时文件（这样才能识别 vim.xxx API）
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false, -- 避免每次弹窗提示“是否配置第三方库”
        },
        telemetry = { enable = false },
      },
    },
  }
end

return M