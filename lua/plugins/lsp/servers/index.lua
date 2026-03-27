local M = {}

-- 动态加载服务器配置模块
local server_modules = {
  ["jdtls"] = function() return require("plugins.lsp.servers.java").get_config() end,
  ["lua_ls"] = function() return require("plugins.lsp.servers.lua").get_config() end,
  ["ts_ls"] = function() return require("plugins.lsp.servers.typescript").get_config() end,
  ["volar"] = function() return require("plugins.lsp.servers.vue").get_config() end,
}

--- 获取指定服务器的配置
function M.get_server_config(server_name)
  local loader = server_modules[server_name]
  if loader then
    return loader()
  end
  return nil
end

--- 获取所有服务器的配置映射
function M.get_all_configs()
  local configs = {}
  for server_name, loader in pairs(server_modules) do
    configs[server_name] = loader()
  end
  return configs
end

return M