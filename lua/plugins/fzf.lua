---@class FzfLuaOpts: lazyvim.util.pick.Opts
---@field cmd string?

-- 注册 fzf-lua picker
local function register_picker()
  -- 强制加载 pick 模块
  local pick = LemurVim.pick

  ---@type LazyPicker
  local picker = {
    name = "fzf",
    commands = {
      files = "files",
    },

    ---@param command string
    ---@param opts? FzfLuaOpts
    open = function(command, opts)
      opts = opts or {}
      if opts.cmd == nil and command == "git_files" and opts.show_untracked then
        opts.cmd = "git ls-files --exclude-standard --cached --others"
      end
      return require("fzf-lua")[command](opts)
    end,
  }

  pick.register(picker)
end

local function symbols_filter(entry, ctx)
  if ctx.symbols_filter == nil then
    -- 默认不过滤符号，显示所有类型
    ctx.symbols_filter = false
  end
  if ctx.symbols_filter == false then
    return true
  end
  return vim.tbl_contains(ctx.symbols_filter, entry.kind)
end

LemurVim.plugins["fzf-lua"] = {
  desc = "基于 FZF 的模糊查找器",
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    opts = function(_, opts)
      local fzf = require("fzf-lua")
      local config = fzf.config
      local actions = fzf.actions

      -- Quickfix
      config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
      config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
      config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
      config.defaults.keymap.fzf["ctrl-x"] = "jump"
      config.defaults.keymap.fzf["ctrl-f"] = "preview-page-down"
      config.defaults.keymap.fzf["ctrl-b"] = "preview-page-up"
      config.defaults.keymap.builtin["<c-f>"] = "preview-page-down"
      config.defaults.keymap.builtin["<c-b>"] = "preview-page-up"

      -- Trouble
      if pcall(require, "trouble") then
        local trouble_status, trouble_fzf = pcall(require, "trouble.sources.fzf")
        if trouble_status and trouble_fzf and trouble_fzf.actions then
          config.defaults.actions.files["ctrl-t"] = trouble_fzf.actions.open
        end
      end

      -- Toggle root dir / cwd
      config.defaults.actions.files["ctrl-r"] = function(_, ctx)
        local o = vim.deepcopy(ctx.__call_opts)
        o.root = o.root == false
        o.cwd = nil
        o.buf = ctx.__CTX.bufnr

        -- 安全访问 LemurVim
        if _G.LemurVim and LemurVim.pick then
          LemurVim.pick.open(ctx.__INFO.cmd, o)
        else
          require("fzf-lua")[ctx.__INFO.cmd](o)
        end
      end
      config.defaults.actions.files["alt-c"] = config.defaults.actions.files["ctrl-r"]
      config.set_action_helpstr(config.defaults.actions.files["ctrl-r"], "toggle-root-dir")

      local img_previewer ---@type string[]?
      for _, v in ipairs({
        { cmd = "ueberzug", args = {} },
        { cmd = "chafa", args = { "{file}", "--format=symbols" } },
        { cmd = "viu", args = { "-b" } },
      }) do
        if vim.fn.executable(v.cmd) == 1 then
          img_previewer = vim.list_extend({ v.cmd }, v.args)
          break
        end
      end

      return {
        "default-title",
        fzf_colors = true,
        fzf_opts = {
          ["--no-scrollbar"] = true,
        },
        defaults = {
          -- formatter = "path.filename_first",
          formatter = "path.dirname_first",
        },
        previewers = {
          builtin = {
            extensions = {
              ["png"] = img_previewer,
              ["jpg"] = img_previewer,
              ["jpeg"] = img_previewer,
              ["gif"] = img_previewer,
              ["webp"] = img_previewer,
            },
            ueberzug_scaler = "fit_contain",
          },
        },
        -- Custom LazyVim option to configure vim.ui.select
        ui_select = function(fzf_opts, items)
          return vim.tbl_deep_extend("force", fzf_opts, {
            prompt = " ",
            winopts = {
              title = " " .. vim.trim((fzf_opts.prompt or "Select"):gsub("%s*:%s*$", "")) .. " ",
              title_pos = "center",
            },
          }, fzf_opts.kind == "codeaction" and {
            winopts = {
              layout = "vertical",
              -- height is number of items minus 15 lines for the preview, with a max of 80% screen height
              height = math.floor(math.min(vim.o.lines * 0.8 - 16, #items + 4) + 0.5) + 16,
              width = 0.5,
              preview = not vim.tbl_isempty(vim.lsp.get_clients({ bufnr = 0, name = "vtsls" })) and {
                layout = "vertical",
                vertical = "down:15,border-top",
                hidden = "hidden",
              } or {
                layout = "vertical",
                vertical = "down:15,border-top",
              },
            },
          } or {
            winopts = {
              width = 0.5,
              -- height is number of items, with a max of 80% screen height
              height = math.floor(math.min(vim.o.lines * 0.8, #items + 4) + 0.5),
            },
          })
        end,
        winopts = {
          width = 0.8,
          height = 0.8,
          row = 0.5,
          col = 0.5,
          preview = {
            scrollchars = { "┃", "" },
          },
        },
        files = {
          cwd_prompt = false,
          actions = {
            ["alt-i"] = { actions.toggle_ignore },
            ["alt-h"] = { actions.toggle_hidden },
          },
        },
        grep = {
          actions = {
            ["alt-i"] = { actions.toggle_ignore },
            ["alt-h"] = { actions.toggle_hidden },
          },
        },
        lsp = {
          symbols = {
            symbol_hl = function(s)
              return "TroubleIcon" .. s
            end,
            symbol_fmt = function(s)
              return s:lower() .. "\t"
            end,
            child_prefix = false,
          },
          code_actions = {
            previewer = vim.fn.executable("delta") == 1 and "codeaction_native" or nil,
          },
        },
      }
    end,
    config = function(_, opts)
      if opts[1] == "default-title" then
        -- use the same prompt for all pickers for profile `default-title` and
        -- profiles that use `default-title` as base profile
        local function fix(t)
          t.prompt = t.prompt ~= nil and " " or nil
          for _, v in pairs(t) do
            if type(v) == "table" then
              fix(v)
            end
          end
          return t
        end
        opts = vim.tbl_deep_extend("force", fix(require("fzf-lua.profiles.default-title")), opts)
        opts[1] = nil
      end
      require("fzf-lua").setup(opts)
    end,
    init = function()
      -- 注册 picker
      register_picker()

      -- 安全处理延迟加载
      local function setup_ui_select()
        if _G.LemurVim then
          vim.ui.select = function(...)
            require("lazy").load({ plugins = { "fzf-lua" } })
            local opts = (_G.LemurVim and LemurVim.opts and LemurVim.opts("fzf-lua")) or {}
            require("fzf-lua").register_ui_select(opts.ui_select or nil)
            return vim.ui.select(...)
          end
        end
      end

      -- 尝试立即设置或延迟设置
      if _G.LemurVim then
        setup_ui_select()
      else
        vim.defer_fn(setup_ui_select, 50)
      end
    end,
    keys = {
      { "<c-j>", "<c-j>", ft = "fzf", mode = "t", nowait = true },
      { "<c-k>", "<c-k>", ft = "fzf", mode = "t", nowait = true },
      {
        "<leader>,",
        LemurVim.pick("buffers", { sort_mru = true, sort_lastused = true }),
        desc = "切换缓冲区",
      },
      { "<leader>/", LemurVim.pick("live_grep"), desc = "Grep 搜索 (根目录)" },
      { "<leader>:", "<cmd>FzfLua command_history<cr>", desc = "命令历史" },
      { "<leader><space>", LemurVim.pick("files"), desc = "查找文件 (根目录)" },
      -- find
      { "<leader>fb", LemurVim.pick("buffers", { sort_mru = true, sort_lastused = true }), desc = "缓冲区" },
      { "<leader>fB", "<cmd>FzfLua buffers<cr>", desc = "缓冲区 (全部)" },
      { "<leader>fc", LemurVim.pick.config_files, desc = "查找配置文件" },
      { "<leader>ff", LemurVim.pick("files"), desc = "查找文件 (根目录)" },
      { "<leader>fF", LemurVim.pick("files", { root = false }), desc = "查找文件 (当前目录)" },
      { "<leader>fg", "<cmd>FzfLua git_files<cr>", desc = "查找文件 (Git)" },
      { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "最近文件" },
      { "<leader>fR", LemurVim.pick("oldfiles", { cwd = vim.uv.cwd() }), desc = "最近文件 (当前目录)" },
      -- git
      { "<leader>gc", "<cmd>FzfLua git_commits<CR>", desc = "Git 提交" },
      { "<leader>gd", "<cmd>FzfLua git_diff<cr>", desc = "Git 差异" },
      { "<leader>gl", "<cmd>FzfLua git_commits<CR>", desc = "Git 提交" },
      { "<leader>gs", "<cmd>FzfLua git_status<CR>", desc = "Git 状态" },
      { "<leader>gS", "<cmd>FzfLua git_stash<cr>", desc = "Git 储藏" },
      -- search
      { '<leader>s"', "<cmd>FzfLua registers<cr>", desc = "寄存器" },
      { "<leader>s/", "<cmd>FzfLua search_history<cr>", desc = "搜索历史" },
      { "<leader>sa", "<cmd>FzfLua autocmds<cr>", desc = "自动命令" },
      { "<leader>sb", "<cmd>FzfLua lines<cr>", desc = "缓冲区行" },
      { "<leader>sc", "<cmd>FzfLua command_history<cr>", desc = "命令历史" },
      { "<leader>sC", "<cmd>FzfLua commands<cr>", desc = "命令" },
      { "<leader>sd", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "工作区诊断" },
      { "<leader>sD", "<cmd>FzfLua diagnostics_document<cr>", desc = "缓冲区诊断" },
      { "<leader>sg", LemurVim.pick("live_grep"), desc = "Grep 搜索 (根目录)" },
      { "<leader>sG", LemurVim.pick("live_grep", { root = false }), desc = "Grep 搜索 (当前目录)" },
      { "<leader>sh", "<cmd>FzfLua help_tags<cr>", desc = "帮助文档" },
      { "<leader>sH", "<cmd>FzfLua highlights<cr>", desc = "高亮组" },
      { "<leader>sj", "<cmd>FzfLua jumps<cr>", desc = "跳转列表" },
      { "<leader>sk", "<cmd>FzfLua keymaps<cr>", desc = "键位映射" },
      { "<leader>sl", "<cmd>FzfLua loclist<cr>", desc = "位置列表" },
      { "<leader>sM", "<cmd>FzfLua man_pages<cr>", desc = "手册页" },
      { "<leader>sm", "<cmd>FzfLua marks<cr>", desc = "跳转到标记" },
      { "<leader>sR", "<cmd>FzfLua resume<cr>", desc = "恢复上次搜索" },
      { "<leader>sq", "<cmd>FzfLua quickfix<cr>", desc = "快速修复列表" },
      { "<leader>sw", LemurVim.pick("grep_cword"), desc = "搜索当前词 (根目录)" },
      { "<leader>sW", LemurVim.pick("grep_cword", { root = false }), desc = "搜索当前词 (当前目录)" },
      { "<leader>sw", LemurVim.pick("grep_visual"), mode = "x", desc = "搜索选中 (根目录)" },
      {
        "<leader>sW",
        LemurVim.pick("grep_visual", { root = false }),
        mode = "x",
        desc = "搜索选中 (当前目录)",
      },

      {
        "<leader>ss",
        function()
          require("fzf-lua").lsp_document_symbols({
            regex_filter = symbols_filter,
          })
        end,
        desc = "跳转符号 (文档)",
      },
      {
        "<leader>sS",
        function()
          require("fzf-lua").lsp_live_workspace_symbols({
            regex_filter = symbols_filter,
          })
        end,
        desc = "跳转符号 (工作区)",
      },
    },
  },

  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    opts = {},
        -- stylua: ignore
        keys = {
          { "<leader>st", function() require("todo-comments.fzf").todo() end, desc = "TODO 注释" },
          { "<leader>sT", function () require("todo-comments.fzf").todo({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "TODO/FIX/FIXME" },
        },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- stylua: ignore
        ["*"] = {
          keys = {
            { "gd", "<cmd>FzfLua lsp_definitions     jump1=true ignore_current_line=true<cr>", desc = "跳转到定义", has = "definition" },
            { "gr", "<cmd>FzfLua lsp_references      jump1=true ignore_current_line=true<cr>", desc = "引用", nowait = true },
            { "gI", "<cmd>FzfLua lsp_implementations jump1=true ignore_current_line=true<cr>", desc = "跳转到实现" },
            { "gy", "<cmd>FzfLua lsp_typedefs        jump1=true ignore_current_line=true<cr>", desc = "跳转到类型定义" },
          }
        },
      },
    },
  },
}
