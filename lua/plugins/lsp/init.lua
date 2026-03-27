local servers = {
  'jdtls',
  'vimls',
  'lua_ls',
  'clangd',
  'bashls',
  'html',
  'cssls',
  'ts_ls',
  'vue_ls',
  'jsonls',
  'tailwindcss',
  'dockerls',
  'docker_compose_language_service',
}

LemurVim.plugins["lsp"] = {
   -- LSP 安装
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',              -- lsp 管理插件
      cmd = 'Mason',
      opts = {
        ui = {
          border = 'rounded',
          width = 0.8,
          height = 0.7,
          icons = {
            package_installed = '󰺧',
            package_pending = '',
            package_uninstalled = '󰺭',
          },
        },
      },
    },
    opts = {
      ensure_installed = servers,
      automatic_installation = true,      -- 打开文件时自动安装缺失的 LSP
    },
  },

   -- LSP 核心配置
  {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    dependencies = {
      { 'folke/neodev.nvim', opts = {}, lazy = false, priority = 1000 },
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      local common = require("plugins.lsp.common")
      local servers_config = require("plugins.lsp.servers")

      -- 设置诊断
      common.setup_diagnostics()

      -- 获取通用配置
      local handlers = common.get_handlers()
      local capabilities = common.get_capabilities()
      local on_attach = common.get_on_attach()

       -- 配置通用服务器
       for _, lsp in ipairs(servers) do
         require("lspconfig")[lsp].setup({
           on_attach = on_attach,
           capabilities = capabilities,
         })
       end

      -- 应用特定服务器配置
      local specific_servers = { "lua_ls", "ts_ls", "volar", "jdtls" }
      for _, server_name in ipairs(specific_servers) do
        local config = servers_config.get_server_config(server_name)
        if config then
         -- 合并配置（保留已有的 on_attach 和 capabilities）
         local existing_config = require("lspconfig")[server_name] or {}
         require("lspconfig")[server_name].setup(vim.tbl_deep_extend("force",
           existing_config,
           config
         ))
        end
      end

       -- 特别处理 lua_ls 的 handlers
       if require("lspconfig")["lua_ls"] then
         require("lspconfig")["lua_ls"].setup({
           handlers = handlers
         })
       end

       -- 特别处理 vue_ls（使用 volar 配置）
       if require("lspconfig")["vue_ls"] and require("lspconfig")["volar"] then
         require("lspconfig")["vue_ls"].setup(vim.tbl_deep_extend("force",
           require("lspconfig")["vue_ls"] or {},
           require("lspconfig")["volar"] or {}
         ))
       end
    end,
  },

  {
    "ngtuonghy/live-server-nvim",
    event = "VeryLazy",
    build = ":LiveServerInstall",
    config = function()
      require("live-server-nvim").setup{
        custom = {
          -- 自定义设置
        }
      }
    end,
  },
}