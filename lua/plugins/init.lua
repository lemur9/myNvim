require("util.lazy") -- lazy包管理插件
LemurVim.plugins = {}

require("plugins.treesitter") -- 代码高亮
require("plugins.neo-tree") -- 文件树
require("plugins.blink") -- 轻量补全框架，提供智能代码补全
require("plugins.snippets") -- 代码片段（LuaSnip + friendly-snippets + 自定义）
require("plugins.fzf") -- 模糊查找

require("plugins.lualine") -- 文件状态展示
require("plugins.theme") -- 主题

-- require("plugins.cmp") -- 代码片段补全
require("plugins.lsp") -- 语法支持
require("plugins.indent-line") -- 方法标识线
require("plugins.bufferline") -- tab页缓冲区

require("plugins.trans") -- 翻译
require("plugins.markdown") -- markdown预览
require("plugins.which-key") -- 按键映射
require("plugins.ide") -- IDE舒适度：自动配对/注释/环绕/快速跳转/折叠
require("plugins.snacks") -- lazy.vim工具类
require("plugins.gitsigns") -- git提示
require("plugins.dashboard") -- 主页
