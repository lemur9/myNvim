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

LemurVim.plugins.lsp = {
  -- lsp installation
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

  -- lsp 核心配置
  {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    dependencies = {
      { 'folke/neodev.nvim', opts = {}, lazy = false, priority = 1000 },
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      local icons = LemurVim.config.icons.diagnostics

      -- 诊断信息设置、快捷键、服务器配置等
      -- 配置提示文本
      vim.diagnostic.config({
        -- 错误信息提示
        virtual_text = true,
        -- 在输入模式下也更新提示，设置为 true 也许会影响性能
        update_in_insert = true,
        float = { border = 'rounded' },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = icons.Error,
            [vim.diagnostic.severity.WARN]  = icons.Warn,
            [vim.diagnostic.severity.INFO]  = icons.Info,
            [vim.diagnostic.severity.HINT]  = icons.Hint,
          },
          numhl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
            [vim.diagnostic.severity.WARN]  = "DiagnosticSignWarn",
            [vim.diagnostic.severity.INFO]  = "DiagnosticSignInfo",
            [vim.diagnostic.severity.HINT]  = "DiagnosticSignHint",
          },
        },
      })

      -- border for float win
      require('lspconfig.ui.windows').default_options.border = 'rounded'
      local handlers = {
        ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' }),
        ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' }),
      }

      -- completion capabilities（仅使用 blink.cmp）
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok_blink, blink = pcall(require, "blink.cmp")
      if ok_blink and blink.get_lsp_capabilities then
        capabilities = blink.get_lsp_capabilities(capabilities)
      end

      -- on attch
      local on_attach = function(client, bufnr)
        -- highlight symbol under cursor
        if client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_augroup('lsp_document_highlight', {
            clear = false,
          })
          vim.api.nvim_clear_autocmds({
            buffer = bufnr,
            group = 'lsp_document_highlight',
          })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            group = 'lsp_document_highlight',
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.document_highlight()
            end,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            group = 'lsp_document_highlight',
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.clear_references()
            end,
          })
        end
      end

      for _, lsp in ipairs(servers) do
        vim.lsp.config[lsp] = {
          on_attach = on_attach,
          capabilities = capabilities,
        }
      end

      -- lua
      vim.lsp.config["lua_ls"] = {
        on_attach = on_attach,
        handlers = handlers,
        capabilities = capabilities,
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

      -- vue
      local vue_language_server_path =
      vim.fn.expand('$MASON/packages/vue-language-server/node_modules/@vue/language-server')
      local typescript_language_server_path =
      vim.fn.expand('$MASON/packages/typescript-language-server/node_modules/typescript/lib')

      vim.lsp.config["ts_ls"] = {
        on_attach = on_attach,
        capabilities = capabilities,
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
      vim.lsp.config["volar"] = {
        on_attach = on_attach,
        capabilities = capabilities,
        init_options = {
          typescript = {
            tsdk = typescript_language_server_path,
          },
        },
      }

      -- 配置 jdtls（基于 Mason 动态路径，避免硬编码）
      local mason_data = vim.fn.stdpath("data")
      local jdtls_dir = vim.fs.joinpath(mason_data, "mason", "packages", "jdtls")
      local jdtls_plugins_dir = vim.fs.joinpath(jdtls_dir, "plugins")
      local lombok_jar = vim.fs.joinpath(jdtls_dir, "lombok.jar")
      local config_name = (vim.fn.has("win32") == 1 and "config_win")
        or (vim.fn.has("mac") == 1 and "config_mac")
        or "config_linux"
      local jdtls_config_dir = vim.fs.joinpath(jdtls_dir, config_name)
      local root_marker = vim.fs.find({ ".git", "pom.xml", "build.gradle" }, { upward = true })[1]
      local jdtls_root = root_marker and vim.fs.dirname(root_marker) or vim.uv.cwd()
      local project_name = vim.fs.basename(jdtls_root)
      local workspace_dir = vim.fs.joinpath(jdtls_dir, "workspace", project_name)

      local launcher_jars = vim.fn.globpath(jdtls_plugins_dir, "org.eclipse.equinox.launcher_*.jar", false, true)
      table.sort(launcher_jars)
      local launcher_jar = launcher_jars[#launcher_jars]

      if launcher_jar then
        vim.lsp.config["jdtls"] = {
          cmd = {
            "java",
            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
            "-Dosgi.bundles.defaultStartLevel=4",
            "-Declipse.product=org.eclipse.jdt.ls.core.product",
            "-Dlog.protocol=true",
            "-Dlog.level=ALL",
            "-Xms1g",
            "--add-modules=ALL-SYSTEM",
            "--add-opens",
            "java.base/java.util=ALL-UNNAMED",
            "--add-opens",
            "java.base/java.lang=ALL-UNNAMED",
            -- 增加 lombok 插件支持
            "-javaagent:" .. lombok_jar,
            "-Xbootclasspath/a:" .. lombok_jar,
            "-jar",
            launcher_jar,
            "-configuration",
            jdtls_config_dir,
            "-data",
            workspace_dir,
          },
          root_dir = jdtls_root,
          init_options = {
            bundles = {},
          },
          settings = {
            java = {
              configuration = {
                annotationProcessing = {
                  enabled = true,
                },
              },
            },
          },
        }
      else
        vim.notify(
          "[lsp] jdtls launcher jar not found under Mason path, keeping default jdtls config",
          vim.log.levels.WARN
        )
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
          "--port=5555",
          "--no-css-inject",
        },
        serverPath = vim.fn.stdpath("data") .. "/live-server/", --default
        open = "folder", -- folder|cwd     --default
      }
    end,
  },
}
