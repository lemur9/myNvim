local picker = require("plugins.fzf.picker")

local M = {}

--- 获取 fzf-lua 配置
function M.get_config()
  local fzf = require("fzf-lua")
  local config = fzf.config
  local actions = fzf.actions

  -- Quickfix 相关配置
  config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
  config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
  config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
  config.defaults.keymap.fzf["ctrl-x"] = "jump"
  config.defaults.keymap.fzf["ctrl-f"] = "preview-page-down"
  config.defaults.keymap.fzf["ctrl-b"] = "preview-page-up"
  config.defaults.keymap.builtin["<c-f>"] = "preview-page-down"
  config.defaults.keymap.builtin["<c-b>"] = "preview-page-up"

  -- Trouble 插件集成
  if pcall(require, "trouble") then
    local trouble_status, trouble_fzf = pcall(require, "trouble.sources.fzf")
    if trouble_status and trouble_fzf and trouble_fzf.actions then
      config.defaults.actions.files["ctrl-t"] = trouble_fzf.actions.open
    end
  end

  -- 切换根目录 / 当前工作目录
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
    -- 自定义 LazyVim 选项，用于配置 vim.ui.select
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
          -- 高度为项目数减去预览的15行，最大为屏幕高度的80%
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
          -- 高度为项目数，最大为屏幕高度的80%
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
end

return M