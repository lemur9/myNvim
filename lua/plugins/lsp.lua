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
      ensure_installed = {            -- 列出需要自动安装的 LSP 服务器
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
      },
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
      local icons = LemurVim.config.icons.diagnostic_icons

      -- 诊断信息设置、快捷键、服务器配置等
      -- 配置提示文本
      vim.diagnostic.config({
        -- 错误信息提示
        virtual_text = true,
        -- 在输入模式下也更新提示，设置为 true 也许会影响性能
        update_in_insert = true,
        float = { border = 'rounded' },
      })

      -- set signs
      -- 对错误警告的图标
      local icons = {
        Error = icons.error,
        Warn = icons.warn,
        Hint = icons.hint,
        Info = icons.info
      }

      -- 使用新 API 配置诊断符号
      vim.diagnostic.config({
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

      -- lsp 快捷键设置
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          local opts = { buffer = ev.buf }
          -- 文档显示
          vim.keymap.set('n', '<space>gh', vim.lsp.buf.hover, opts)
          -- 查看定义
          vim.keymap.set('n', '<space>gd', vim.lsp.buf.definition, opts)
          -- 查询引用
          vim.keymap.set('n', '<space>gr', vim.lsp.buf.references, opts)
          -- 重命名
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
          -- 代码建议
          vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
        end,
      })

      -- border for float win
      require('lspconfig.ui.windows').default_options.border = 'rounded'
      local handlers = {
        ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' }),
        ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' }),
      }

      -- autocompletion
      -- local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

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

      local servers = {
        'jdtls',
        'vimls',
        'clangd',
        'bashls',
        'html',
        'cssls',
        'jsonls',
        'tailwindcss',
        'dockerls',
        'docker_compose_language_service',
      }
      for _, lsp in ipairs(servers) do
        vim.lsp.config[lsp] = {
          on_attach = on_attach,
          -- capabilities = capabilities,
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

      -- 配置 jdtls
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
          --增加lombok插件支持，getter setter good bye
          "-javaagent:/home/lemur/.local/share/nvim/mason/packages/jdtls/lombok.jar",
          "-Xbootclasspath/a:/home/lemur/.local/share/nvim/mason/packages/jdtls/lombok.jar",
          "-jar",
          "/home/lemur/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.7.100.v20251014-1222.jar",
          "-configuration",
          "/home/lemur/.local/share/nvim/mason/packages/jdtls/config_linux",
          "-data",
          "/home/lemur/.local/share/nvim/mason/packages/jdtls/workspace/folder"
        },
        root_dir = vim.fs.dirname(vim.fs.find({".git", "pom.xml", "build.gradle"}, { upward = true })[1]),
        init_options = {
          bundles = {
          }
        },
        settings = {
          java = {
            -- 启用 Lombok 注解处理
            configuration = {
              annotationProcessing = {
                enabled = true
              }
            }
          }
        }
      }
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
