-- 主题管理模块。
-- 负责：主题注册、应用主题（懒加载插件 -> setup -> colorscheme -> 触发事件）、
--       选择结果持久化、用 fzf-lua 选择主题。
-- 参考 IceNvim 的 "IceAfter colorscheme" 机制：应用主题后触发一个 User 事件，
-- 让 dashboard 等依赖主题的插件在主题设置完成后再加载。
local M = {}

-- 主题应用完成后触发的事件。dashboard 监听它来懒加载。
M.event = "LemurAfter colorscheme"

-- 持久化上次使用主题的文件（位于 stdpath("data")，不属于配置仓库）
M.cache_file = vim.fs.joinpath(vim.fn.stdpath("data"), "colorscheme")

-- 可用主题注册表。
-- key 同时扮演三个角色：
--   1. colorscheme 名（:colorscheme <key>）
--   2. 插件模块名（require("<key>")）
--   3. lazy.nvim 懒加载匹配名（插件仓库内的 colors/<key>.lua|.vim）
M.themes = {
  tokyonight = {
    repo = "folke/tokyonight.nvim",
    background = "dark",
    setup = { style = "moon" },
  },
  catppuccin = {
    repo = "catppuccin/nvim",
    background = "dark",
    setup = { flavour = "mocha" },
  },
  nightfox = {
    repo = "EdenEast/nightfox.nvim",
    background = "dark",
  },
  kanagawa = {
    repo = "rebelot/kanagawa.nvim",
    background = "dark",
  },
  onedark = {
    repo = "navarasu/onedark.nvim",
    background = "dark",
  },
  ["rose-pine"] = {
    repo = "rose-pine/neovim",
    background = "dark",
  },
}

-- 默认主题
M.default = "tokyonight"

-- 当前主题名
M.current = nil

-- 读取上次使用的主题，失败则回退到默认主题
function M.load()
  if M.current then
    return M.current
  end
  local f = io.open(M.cache_file, "r")
  local name = f and f:read("*l") or ""
  if f then
    f:close()
  end
  name = vim.trim(name)
  M.current = M.themes[name] and name or M.default
  return M.current
end

-- 持久化当前主题
function M.save(name)
  local ok, err = pcall(function()
    local f = assert(io.open(M.cache_file, "w"))
    f:write(name)
    f:close()
  end)
  if not ok then
    LemurVim.warn("无法保存主题选择: " .. tostring(err))
  end
end

-- 应用主题：懒加载插件 -> setup -> colorscheme -> 触发事件
function M.set(name)
  local theme = M.themes[name]
  if not theme then
    LemurVim.warn("未知主题: " .. tostring(name))
    return
  end

  -- 让 lazy.nvim 加载主题插件（主题已注册时该函数直接返回，幂等）
  local ok, loader = pcall(require, "lazy.core.loader")
  if ok then
    loader.colorscheme(name)
  end

  if type(theme.setup) == "function" then
    theme.setup()
  elseif type(theme.setup) == "table" then
    require(name).setup(theme.setup)
  end

  if theme.background then
    vim.o.background = theme.background
  end
  vim.cmd("colorscheme " .. name)

  M.current = name
  M.save(name)

  -- 触发事件，让 dashboard 等依赖主题的插件加载 / 刷新
  vim.api.nvim_exec_autocmds("User", { pattern = M.event })
end

-- 用 fzf-lua 选择主题
function M.select()
  -- fzf-lua 是懒加载的，先确保已加载
  require("lazy").load({ plugins = { "fzf-lua" } })

  local names = {}
  for name in pairs(M.themes) do
    names[#names + 1] = name
  end
  table.sort(names)

  require("fzf-lua").fzf_exec(names, {
    prompt = "Theme > ",
    actions = {
      ["default"] = function(selected)
        M.set(selected[1])
      end,
    },
  })
end

return M
