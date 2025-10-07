-- 该配置文件主要有3部分组成：

--  1.lazy.nvim的加载与存在性验证:lazy.nvim进行存在性检查。如果不存在，则通过git clone方式，下载lazy.nvim模块代码，并存放到stdpath("data")/lazy/lazy.nvim目录下
--  2.将lazy.nvim模块所在目录加入到lua模块搜索路径下，以便可以require到lazy.nvim模块；
--  3.让lazy.nvim加载插件。

-- 1. 准备lazy.nvim模块（存在性检测）
-- stdpath("data") Linux: ~/.local/share/nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

-- 2. 将 lazypath 设置为运行时路径
vim.opt.rtp:prepend(lazypath)

-- 日志调试开关("debug")
-- vim.lsp.set_log_level("WARN")  -- 或 "off"

-- 3. 加载lazy.nvim模块
-- require("lazy").setup("plugins")
require("lazy").setup({
    require("plugins.lualine"),             -- 文件状态展示
    require("plugins.nvim-tree"),           -- 文件树
    require("plugins.theme-night"),         -- 主题
    require("plugins.treesitter"),          -- 代码高亮
    require("plugins.telescope"),           -- 文件搜索

    require("plugins.cmp"),                 -- 代码片段补全
    require("plugins.lsp"),                 -- 语法支持
    require("plugins.trans"),               -- 翻译
    require("plugins.indent-line"),         -- 方法标识线
    require("plugins.bufferline"),          -- tab页缓冲区
    require("plugins.vimcdoc"),             -- vim中文帮助文档
    require("plugins.clipboard"),
    require("plugins.markdown"),            -- markdown预览
    require("plugins.which-key"),           -- 按键映射
})
