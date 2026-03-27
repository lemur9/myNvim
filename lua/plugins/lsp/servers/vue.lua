local M = {}

--- 获取 volar 配置（Vue LSP）
function M.get_config()
  local typescript_language_server_path =
    vim.fn.expand('$MASON/packages/typescript-language-server/node_modules/typescript/lib')

  return {
    init_options = {
      typescript = {
        tsdk = typescript_language_server_path,
      },
    },
  }
end

return M