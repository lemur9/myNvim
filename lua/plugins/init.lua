require("util.lazy") -- lazy包管理插件
LemurVim.plugins = {}

require("plugins.treesitter") -- 代码高亮
require("plugins.neo-tree") -- 文件树
require("plugins.blink") -- 轻量补全框架，提供智能代码补全
require("plugins.fzf") -- 轻量补全框架，提供智能代码补全

require("plugins.lualine") -- 文件状态展示
require("plugins.theme-night") -- 主题
-- require("plugins.telescope")           -- 文件搜索

-- require("plugins.cmp") -- 代码片段补全
require("plugins.lsp") -- 语法支持
require("plugins.indent-line") -- 方法标识线
require("plugins.bufferline") -- tab页缓冲区

require("plugins.trans") -- 翻译
require("plugins.vimcdoc") -- vim中文帮助文档
require("plugins.markdown") -- markdown预览
require("plugins.which-key") -- 按键映射
