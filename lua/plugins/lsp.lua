LemurVim.plugins.lsp = {
  -- lsp installation
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim", -- lsp 管理插件
      cmd = "Mason",
      opts = {
        ui = {
          border = "rounded",
          width = 0.8,
          height = 0.7,
          icons = {
            package_installed = "󰺧",
            package_pending = "",
            package_uninstalled = "󰺭",
          },
        },
      },
    },
    opts = {
      ensure_installed = { -- 列出需要自动安装的 LSP 服务器
        "jdtls", -- Java（配了 lombok 支持）
        "vimls",
        "lua_ls",
        -- "clangd", -- C/C++，需要时取消注释
        "bashls",
        "html",
        "cssls",
        "ts_ls",
        "vue_ls",
        "jsonls",
        "tailwindcss",
        -- "dockerls", -- 需要时取消注释
        -- "docker_compose_language_service",
      },
      automatic_installation = true, -- 打开文件时自动安装缺失的 LSP
    },
  },

  -- lsp 核心配置
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {
      { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
      local icons = LemurVim.config.icons.diagnostics

      -- 保存时自动格式化（默认关闭，需要时用 :FormatOnSave 或 <leader>uf 打开）
      -- 全局开关：vim.g.autoformat；单缓冲区开关：vim.b.autoformat
      vim.g.autoformat = false

      local format_group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = true })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = format_group,
        callback = function(args)
          -- 全局关闭或当前 buffer 关闭时，跳过格式化
          if vim.g.autoformat == false or vim.b[args.buf].autoformat == false then
            return
          end
          pcall(vim.lsp.buf.format, { bufnr = args.buf, timeout_ms = 2000 })
        end,
      })

      -- 命令：全局 / 当前缓冲区切换保存时自动格式化
      vim.api.nvim_create_user_command("FormatOnSave", function()
        vim.g.autoformat = true
        vim.notify("已开启：保存时自动格式化（全局）", vim.log.levels.INFO)
      end, { desc = "开启保存时自动格式化（全局）" })

      vim.api.nvim_create_user_command("NoFormatOnSave", function()
        vim.g.autoformat = false
        vim.notify("已关闭：保存时自动格式化（全局）", vim.log.levels.INFO)
      end, { desc = "关闭保存时自动格式化（全局）" })

      vim.api.nvim_create_user_command("FormatOnSaveToggle", function()
        vim.g.autoformat = not vim.g.autoformat
        vim.notify(
          (vim.g.autoformat and "已开启" or "已关闭") .. "：保存时自动格式化（全局）",
          vim.log.levels.INFO
        )
      end, { desc = "切换保存时自动格式化（全局）" })

      vim.api.nvim_create_user_command("FormatBufferOnSave", function()
        vim.b.autoformat = true
        vim.notify("已开启：当前缓冲区保存时自动格式化", vim.log.levels.INFO)
      end, { desc = "开启当前缓冲区保存时自动格式化" })

      vim.api.nvim_create_user_command("NoFormatBufferOnSave", function()
        vim.b.autoformat = false
        vim.notify("已关闭：当前缓冲区保存时自动格式化", vim.log.levels.INFO)
      end, { desc = "关闭当前缓冲区保存时自动格式化" })

      -- 快捷键：<leader>uf 全局切换
      vim.keymap.set("n", "<leader>uf", "<cmd>FormatOnSaveToggle<cr>", { desc = "切换保存时自动格式化" })

      -- 诊断导航：]d / [d 跳到下一个/上一个诊断（错误、警告等）
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "下一个诊断" })
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "上一个诊断" })

      -- 诊断信息设置、快捷键、服务器配置等
      -- 配置提示文本
      vim.diagnostic.config({
        -- 错误信息提示
        virtual_text = true,
        -- 在输入模式下也更新提示，设置为 true 也许会影响性能
        update_in_insert = true,
        float = { border = "rounded" },
      })

      -- 使用新 API 配置诊断符号
      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = icons.Error,
            [vim.diagnostic.severity.WARN] = icons.Warn,
            [vim.diagnostic.severity.INFO] = icons.Info,
            [vim.diagnostic.severity.HINT] = icons.Hint,
          },
          numhl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
            [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
            [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
            [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
          },
        },
      })

      -- lsp 快捷键设置
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          -- 悬停文档
          vim.keymap.set("n", "<space>gh", vim.lsp.buf.hover, { buffer = ev.buf, desc = "LSP 悬停文档" })
          -- 跳转到定义
          vim.keymap.set("n", "<space>gd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "跳转到定义" })
          -- 查询引用
          vim.keymap.set("n", "<space>gr", vim.lsp.buf.references, { buffer = ev.buf, desc = "查询引用" })
          -- 重命名
          vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "重命名符号" })
          -- 代码操作
          vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "代码操作" })
        end,
      })

      -- border for float win (nvim 0.11+)
      vim.o.winborder = "rounded"

      -- autocompletion
      -- 获取 LSP 客户端能力配置
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      -- 如果使用 blink.cmp，尝试获取其 capabilities
      local has_blink, blink = pcall(require, "blink.cmp")
      if has_blink and blink.get_lsp_capabilities then
        capabilities = vim.tbl_deep_extend("force", capabilities, blink.get_lsp_capabilities())
      end

      -- on attch
      local on_attach = function(client, bufnr)
        -- highlight symbol under cursor
        if client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_augroup("lsp_document_highlight", {
            clear = false,
          })
          vim.api.nvim_clear_autocmds({
            buffer = bufnr,
            group = "lsp_document_highlight",
          })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = "lsp_document_highlight",
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.document_highlight()
            end,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            group = "lsp_document_highlight",
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.clear_references()
            end,
          })
        end
      end

      local servers = {
        "jdtls",
        "vimls",
        "clangd",
        "bashls",
        "html",
        "cssls",
        "jsonls",
        "tailwindcss",
        "dockerls",
        "docker_compose_language_service",
      }
      for _, lsp in ipairs(servers) do
        vim.lsp.config[lsp] = {
          on_attach = on_attach,
          capabilities = capabilities,
        }
      end

      -- lua
      vim.lsp.config["lua_ls"] = {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              -- 告诉语言服务器你在用的是 LuaJIT（Neovim 内置 Lua 版本）
              version = "LuaJIT",
            },
            diagnostics = {
              -- 让 LSP 识别 Neovim 的全局变量
              globals = { "vim" },
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

      -- vue（Mason 安装目录统一使用 stdpath('data')）
      local mason_packages = vim.fn.stdpath("data") .. "/mason/packages"
      local vue_language_server_path = mason_packages .. "/vue-language-server/node_modules/@vue/language-server"
      local typescript_language_server_path = mason_packages
        .. "/typescript-language-server/node_modules/typescript/lib"

      vim.lsp.config["ts_ls"] = {
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
        init_options = {
          plugins = {
            {
              name = "@vue/typescript-plugin",
              location = vue_language_server_path,
              languages = { "vue" },
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
          "-javaagent:" .. vim.fn.stdpath("data") .. "/mason/packages/jdtls/lombok.jar",
          "-Xbootclasspath/a:" .. vim.fn.stdpath("data") .. "/mason/packages/jdtls/lombok.jar",
          "-jar",
          vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
          "-configuration",
          vim.fn.stdpath("data") .. "/mason/packages/jdtls/config_linux",
          "-data",
          vim.fn.stdpath("data") .. "/mason/packages/jdtls/workspace/folder",
        },
        root_dir = function()
          local marker = vim.fs.find({ ".git", "pom.xml", "build.gradle" }, { upward = true })[1]
          return marker and vim.fs.dirname(marker) or vim.uv.cwd()
        end,
        init_options = {
          bundles = {},
        },
        settings = {
          java = {
            -- 启用 Lombok 注解处理
            configuration = {
              annotationProcessing = {
                enabled = true,
              },
            },
          },
        },
      }
    end,
  },

  {
    "ngtuonghy/live-server-nvim",
    event = "VeryLazy",
    build = ":LiveServerInstall",
    config = function()
      require("live-server-nvim").setup({
        custom = {
          "--port=5555",
          "--no-css-inject",
        },
        serverPath = vim.fn.stdpath("data") .. "/live-server/", --default
        open = "folder", -- folder|cwd     --default
      })
    end,
  },
}
