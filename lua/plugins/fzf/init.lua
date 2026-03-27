local picker = require("plugins.fzf.picker")
local config = require("plugins.fzf.config")

LemurVim.plugins["fzf-lua"] = {
  desc = "Awesome picker for FZF (alternative to Telescope)",
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    opts = function(_, opts)
      return config.get_config()
    end,
    config = function(_, opts)
      if opts[1] == "default-title" then
         -- 为所有使用 `default-title` 配置文件的 picker 使用相同的提示符
         -- 以及将 `default-title` 作为基础配置文件的配置文件
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

  },




}