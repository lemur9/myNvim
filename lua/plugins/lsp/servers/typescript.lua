local M = {}

--- 获取 ts_ls 配置
function M.get_config()
  local vue_language_server_path =
    vim.fn.expand('$MASON/packages/vue-language-server/node_modules/@vue/language-server')
  local typescript_language_server_path =
    vim.fn.expand('$MASON/packages/typescript-language-server/node_modules/typescript/lib')

  return {
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
    init_options = {
      plugins = {
        {
          name = '@vue/typescript-plugin',
          location = vue_language_server_path,
          languages = { 'vue' },
        },
      },
    },
  }
end

return M