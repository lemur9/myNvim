-- 基础设置
-- 设置 Python3 的路径，用于 Neovim 的 Python 插件支持
LemurVim.G.g.python3_host_prog = os.getenv("PYTHON") -- export PYTHON=$(which python3)
LemurVim.G.g.editorconfig = false -- 禁用 editorconfig 支持
LemurVim.G.opt.showcmd = true -- 在状态栏显示当前命令
LemurVim.G.opt.encoding = "utf-8" -- 设置编码为 UTF-8
LemurVim.G.opt.wildmenu = true -- 启用命令行补全菜单

-- 编辑器行为设置
LemurVim.G.opt.hlsearch = false -- 高亮搜索结果
LemurVim.G.opt.showmatch = true -- 匹配括号高亮显示
LemurVim.G.opt.incsearch = true -- 即时显示匹配结果
LemurVim.G.opt.backspace = "indent,eol,start" -- 设置退格键的行为
LemurVim.G.opt.whichwrap = "b,s,<,>,h," -- 设置哪些键可以在行首行尾换行
LemurVim.G.opt.vb = true -- 禁用可视铃声
LemurVim.G.opt.hidden = true -- 允许隐藏修改过的缓冲区
LemurVim.G.opt.autoread = true -- 自动重新加载外部修改的内容

-- 缩进和制表符设置
LemurVim.G.opt.autoindent = true -- 启用自动缩进
LemurVim.G.opt.softtabstop = 4 -- 设置软制表符宽度为 4
LemurVim.G.opt.smarttab = true -- 在行首按Tab时使用 shiftwidth 的值
LemurVim.G.opt.shiftwidth = 0 -- 缩进宽度与tabstop一致

-- 文件和备份设置
LemurVim.G.opt.backup = false -- 禁用备份文件
LemurVim.G.opt.swapfile = false -- 禁用交换文件
LemurVim.G.opt.undofile = true -- 启用撤销文件
LemurVim.G.opt.undodir = os.getenv("HOME") .. "/.config/nvim/cache/undodir" -- 设置撤销文件存储目录
LemurVim.G.opt.viminfo = "!,'10000,<50,s10,h" -- 设置viminfo选项

-- 折叠设置
LemurVim.G.opt.foldenable = true -- 启用代码折叠
LemurVim.G.opt.foldmethod = "indent" -- 使用缩进方式折叠
LemurVim.G.opt.foldlevel = 99 -- 设置折叠级别
LemurVim.G.opt.viewdir = os.getenv("HOME") .. "/.config/nvim/cache/viewdir" -- 设置视图文件存储目录
LemurVim.G.opt.foldtext = "v:lua.MagicFoldText()" -- 自定义折叠文本显示函数

-- 行号设置
LemurVim.G.opt.cmdheight = 1 -- 设置命令行高度
LemurVim.G.opt.numberwidth = 2 -- 设置行号列宽度
LemurVim.G.opt.cul = true -- 高亮光标所在行
LemurVim.G.opt.number = true -- 显示行号
LemurVim.G.opt.relativenumber = true -- 显示相对行号
LemurVim.G.opt.cursorline = true -- 启用当前行高亮显示
LemurVim.G.opt.termguicolors = true -- 启用真彩色支持
LemurVim.G.opt.scrolloff = 4 -- 垂直滚动时保持的上下文行数
LemurVim.G.opt.sidescrolloff = 8 -- 水平滚动时保持的左右上下文列数
LemurVim.G.opt.signcolumn = "yes" -- 始终显示标志列，避免文本跳动

LemurVim.G.g.loaded_netrw = 1 -- 禁用内置的文件浏览器插件 netrw
LemurVim.G.g.loaded_netrwPlugin = 1

-- 此文件由 plugins.core 自动加载
LemurVim.G.g.mapleader = " " -- 设置全局映射前导键为空格键
LemurVim.G.g.maplocalleader = "\\" -- 设置局部映射前导键为反斜杠

-- LazyVim 自动格式化设置
LemurVim.G.g.autoformat = true -- 启用自动格式化功能

-- Snacks 动画设置
-- 设置为 `false` 可全局禁用所有 snacks 动画
LemurVim.G.g.snacks_animate = true -- 启用 snacks 动画效果

-- LazyVim 选择器设置
-- 可选值: telescope, fzf
-- 设置为 "auto" 可自动使用通过 `:LazyExtras` 启用的选择器
LemurVim.G.g.lazyvim_picker = "auto" -- 自动选择文件/符号选择器

-- LazyVim 代码补全引擎设置
-- 可选值: nvim-cmp, blink.cmp
-- 设置为 "auto" 可自动使用通过 `:LazyExtras` 启用的补全引擎
LemurVim.G.g.lazyvim_cmp = "auto" -- 自动选择代码补全引擎

-- 如果补全引擎支持 AI 源，则优先使用而非内联建议
LemurVim.G.g.ai_cmp = true -- 启用 AI 补全源

-- LazyVim 根目录检测设置
-- 每个条目可以是：
-- * 检测器函数名称，如 `lsp` 或 `cwd`
-- * 模式或模式数组，如 `.git` 或 `lua`
-- * 签名为 `function(buf) -> string|string[]` 的函数
LemurVim.G.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" } -- 根目录检测规则

-- 可选的终端设置
-- 这会设置 `vim.o.shell` 并为以下终端做额外配置：
-- * pwsh
-- * powershell
-- LazyVim.terminal.setup("pwsh")  -- 终端环境配置（已注释）

-- 设置在使用 `util.root.detectors.lsp` 检测 LSP 根目录时需要忽略的 LSP 服务器
LemurVim.G.g.root_lsp_ignore = { "copilot" } -- 忽略 Copilot LSP 服务器用于根目录检测

-- 隐藏弃用警告
LemurVim.G.g.deprecation_warnings = false -- 禁用弃用警告提示

-- 在 lualine 状态栏中显示来自 Trouble 的当前文档符号位置
-- 可通过设置 `vim.b.trouble_lualine = false` 为缓冲区禁用此功能
LemurVim.G.g.trouble_lualine = true -- 启用 Trouble 插件的 lualine 集成

LemurVim.G.opt.autowrite = true -- 启用自动写入（离开缓冲区时自动保存）
-- 仅在非 SSH 环境下设置剪贴板，确保 OSC 52 集成能自动工作
LemurVim.G.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- 与系统剪贴板同步
LemurVim.G.opt.completeopt = "menu,menuone,noselect" -- 补全菜单选项设置
LemurVim.G.opt.conceallevel = 2 -- 隐藏粗体和斜体的 * 标记，但不隐藏替换标记
LemurVim.G.opt.confirm = true -- 退出修改后的缓冲区前确认是否保存更改
LemurVim.G.opt.expandtab = true -- 使用空格代替制表符
LemurVim.G.opt.fillchars = { -- 设置各种填充字符
	foldopen = "", -- 折叠展开时的图标
	foldclose = "", -- 折叠关闭时的图标
	fold = " ", -- 折叠区域填充字符
	foldsep = " ", -- 折叠分隔符
	diff = "╱", -- 差异区域填充字符
	eob = " ", -- 文件结尾填充字符
}
-- LemurVim.G.opt.formatexpr = "v:lua.LazyVim.format.formatexpr()"  -- 设置格式化表达式
LemurVim.G.opt.formatoptions = "jcroqlnt" -- tcqj 格式化选项
LemurVim.G.opt.grepformat = "%f:%l:%c:%m" -- grep 输出格式
LemurVim.G.opt.grepprg = "rg --vimgrep" -- 使用 ripgrep 作为 grep 程序
LemurVim.G.opt.ignorecase = true -- 搜索时忽略大小写
LemurVim.G.opt.inccommand = "nosplit" -- 增量替换时预览效果但不分割窗口
LemurVim.G.opt.jumpoptions = "view" -- 跳转时保存和恢复视图
LemurVim.G.opt.laststatus = 3 -- 全局状态栏（3表示只有一个全局状态栏）
LemurVim.G.opt.linebreak = true -- 在便利位置换行（避免在单词中间断开）
LemurVim.G.opt.list = true -- 显示某些不可见字符（如制表符）
LemurVim.G.opt.mouse = "a" -- 启用鼠标模式（a表示所有模式）
LemurVim.G.opt.pumblend = 10 -- 弹出菜单透明度
LemurVim.G.opt.pumheight = 10 -- 弹出菜单最大条目数
LemurVim.G.opt.ruler = false -- 禁用默认标尺
LemurVim.G.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" } -- 会话选项
LemurVim.G.opt.shiftround = true -- 缩进时四舍五入到 shiftwidth 的倍数
LemurVim.G.opt.shortmess:append({ W = true, I = true, c = true, C = true }) -- 精简消息显示
LemurVim.G.opt.showmode = false -- 不显示模式（因为我们有状态栏）
LemurVim.G.opt.smartcase = true -- 智能大小写匹配（有大写字母时不忽略大小写）
LemurVim.G.opt.smartindent = true -- 自动插入智能缩进
LemurVim.G.opt.smoothscroll = true -- 启用平滑滚动
LemurVim.G.opt.spelllang = { "en" } -- 拼写检查语言设置为英语
LemurVim.G.opt.splitbelow = true -- 新窗口在当前窗口下方分割
LemurVim.G.opt.splitkeep = "screen" -- 分割窗口时保持屏幕内容
LemurVim.G.opt.splitright = true -- 新窗口在当前窗口右侧分割
-- LemurVim.G.opt.statuscolumn = [[%!v:lua.LazyVim.statuscolumn()]]              -- 自定义状态列
LemurVim.G.opt.tabstop = 2 -- 制表符宽度为 2 个空格
LemurVim.G.opt.timeoutlen = LemurVim.G.g.vscode and 1000 or 300 -- 键盘超时时间（降低以快速触发 which-key）
LemurVim.G.opt.undofile = true -- 启用撤销文件持久化
LemurVim.G.opt.undolevels = 10000 -- 设置撤销级别
LemurVim.G.opt.updatetime = 200 -- 更新时间间隔（保存交换文件并触发 CursorHold）
LemurVim.G.opt.virtualedit = "block" -- 在可视块模式下允许光标移动到无文本区域
LemurVim.G.opt.wildmode = "longest:full,full" -- 命令行补全模式
LemurVim.G.opt.winminwidth = 5 -- 窗口最小宽度
LemurVim.G.opt.wrap = false -- 禁用自动换行

-- 修复 markdown 缩进设置
LemurVim.G.g.markdown_recommended_style = 0 -- 禁用 markdown 推荐样式

-- 终端相关设置命令
-- 设置插入模式光标样式
-- 设置正常模式光标样式
-- 禁用视觉铃声
-- 禁用背景色擦除
LemurVim.G.command([[
    hi Normal ctermfg=7 ctermbg=NONE cterm=NONE
    let &t_SI .= '\e[5 q'
    let &t_EI .= '\e[1 q'
    let &t_vb = ''
    let &t_ut = ''
]])

-- 这是一个自定义函数，用于美化代码折叠时的显示文本
function MagicFoldText()
	-- 创建替换制表符的空格文本
	local spacetext = ("        "):sub(0, LemurVim.G.opt.shiftwidth:get0())
	-- 获取折叠开始行的内容，并将制表符替换为空格
	local line = LemurVim.G.fn.getline(LemurVim.G.v.foldstart):gsub("\t", spacetext)
	-- 计算折叠的行数
	local folded = LemurVim.G.v.foldend - LemurVim.G.v.foldstart + 1
	-- 查找第一个非空白字符的位置
	local findresult = line:find("%S")
	-- 如果整行都是空白，则返回简单的折叠信息
	if not findresult then
		return "+ folded " .. folded .. " lines "
	end
	-- 计算行首空白字符的数量
	local empty = findresult - 1
	-- 定义不同缩进级别的处理函数
	local funcs = {
		[0] = function(_)
			return "" .. line
		end, -- 无缩进
		[1] = function(_)
			return "+" .. line:sub(2)
		end, -- 1个字符缩进
		[2] = function(_)
			return "+ " .. line:sub(3)
		end, -- 2个字符缩进
		[-1] = function(c) -- 更多缩进的处理
			local result = " " .. line:sub(c + 1)
			local foldednumlen = #tostring(folded)
			for _ = 1, c - 2 - foldednumlen do
				result = "-" .. result
			end
			return "+" .. folded .. result
		end,
	}
	-- 根据缩进数量选择相应的处理函数，并添加折叠行数信息
	return funcs[empty <= 2 and empty or -1](empty) .. " folded " .. folded .. " lines "
end
