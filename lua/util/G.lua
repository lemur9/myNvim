local G = {}

G.g = vim.g
G.b = vim.b
G.o = vim.o
G.v = vim.v
G.fn = vim.fn
G.api = vim.api
G.opt = vim.opt
G.treesitter = vim.treesitter

function G.maps(maps)
  for _, map in pairs(maps) do
    vim.keymap.set(map[1], map[2], map[3], map[4])
  end
end

-- 批量设置快捷键
function G.map(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts or {})
end

-- 批量设置高亮
-- usage: G.hi({
--     ["HIGROUP1"] = { fg = 71, bg = 3, italic = false, bold = true },
--     ["HIGROUP2"] = { fg = 71, italic = true, strikethrough = true },
--     ...,
-- })
function G.hi(hls)
  local colormode = G.o.termguicolors and "" or "cterm"
  for group, color in pairs(hls) do
    local opt = {}
    if color.fg then
      opt[colormode .. "fg"] = color.fg
    end
    if color.bg then
      opt[colormode .. "bg"] = color.bg
    end
    if color.bold ~= nil then
      opt.bold = color.bold
    end
    if color.underline ~= nil then
      opt.underline = color.underline
    end
    if color.italic ~= nil then
      opt.italic = color.italic
    end
    if color.strikethrough ~= nil then
      opt.strikethrough = color.strikethrough
    end
    G.api.nvim_set_hl(0, group, opt)
  end
end

function G.command(cmd)
  G.api.nvim_command(cmd)
end

function G.eval(c)
  return G.api.nvim_eval(c)
end

return G
