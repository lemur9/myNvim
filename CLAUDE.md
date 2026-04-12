# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

这是一个基于 Neovim 的个人配置仓库（LemurVim），使用 Lua 编写，采用模块化架构设计。配置使用 lazy.nvim 作为插件管理器，提供了完整的 IDE 功能。

## 核心架构

### 全局命名空间

- `LemurVim` - 全局命名空间，通过 `_G.LemurVim = require("util")` 初始化
- `LemurVim.G` - Vim API 快捷访问层（`lua/util/G.lua`），封装了 `vim.api`、`vim.fn` 等常用接口
- `LemurVim.config` - 配置管理模块，包含 icons 等配置项
- `LemurVim.plugins` - 插件配置表，所有插件配置都注册到此表中
- `LemurVim.lazy` - lazy.nvim 的配置选项
- `LemurVim.version` - 当前版本号（定义在 `lua/core/init.lua`）

### 模块加载机制

`lua/util/init.lua` 使用 metatable 实现懒加载：
```lua
setmetatable(M, {
  __index = function(t, k)
    t[k] = require("util." .. k)
    return t[k]
  end,
})
```

访问 `LemurVim.icons` 时自动加载 `lua/util/icons.lua`，访问 `LemurVim.cmp` 时自动加载 `lua/util/cmp.lua`。

### 目录结构

```
lua/
├── core/           # 核心配置
│   ├── init.lua    # 配置初始化，定义 LemurVim.config
│   ├── options.lua # Vim 选项设置
│   ├── keymaps.lua # 全局快捷键映射
│   └── autocmd.lua # 自动命令（主要是 markdown 文件类型配置）
├── plugins/        # 插件配置
│   ├── init.lua    # 插件加载入口
│   ├── blink.lua   # blink.cmp 补全框架
│   ├── lsp.lua     # LSP 配置（mason、lspconfig）
│   ├── fzf.lua     # fzf-lua 模糊查找
│   ├── neo-tree.lua # 文件树
│   └── ...         # 其他插件配置
└── util/           # 工具模块
    ├── init.lua    # 工具模块入口（懒加载）
    ├── G.lua       # Vim API 封装
    ├── icons.lua   # 图标定义
    ├── cmp.lua     # 补全相关工具
    ├── lazy.lua    # lazy.nvim 初始化
    ├── plugin.lua  # 插件工具（LazyFile 事件）
    └── pick.lua    # 选择器工具
```

## 插件配置模式

所有插件配置遵循统一模式：

```lua
LemurVim.plugins["plugin-name"] = {
  {
    "author/plugin-repo",
    event = "VeryLazy",  -- 或其他懒加载事件
    opts = { ... },
    config = function() ... end,
  },
}
```

插件配置文件通过 `require("plugins.xxx")` 在 `lua/plugins/init.lua` 中加载，最终所有插件通过 `vim.tbl_values(LemurVim.plugins)` 传递给 lazy.nvim。

## 关键插件

### LSP 配置（lua/plugins/lsp.lua）

- 使用 mason.nvim + mason-lspconfig.nvim 管理 LSP 服务器
- 自动安装的 LSP：jdtls, lua_ls, clangd, bashls, html, cssls, ts_ls, vue_ls, jsonls, tailwindcss, dockerls
- Java LSP (jdtls) 有特殊配置，包含 Lombok 注解处理支持
- LSP 快捷键通过 LspAttach 自动命令设置：
  - `K` - 查看文档
  - `<space>gd` - 跳转到定义
  - `<space>gD` - 跳转到声明
  - `<space>rn` - 重命名
  - `<space>ca` - 代码操作

### 补全框架（lua/plugins/blink.lua）

- 使用 blink.cmp 替代 nvim-cmp（nvim-cmp 已禁用）
- 集成 friendly-snippets 和 blink.compat
- 补全源：lsp, path, snippets, buffer
- 支持命令行补全（cmdline）
- 快捷键：`<C-y>` 选择并接受，`<Tab>` 用于代码片段跳转和 AI 补全

### 模糊查找（lua/plugins/fzf.lua）

- 使用 fzf-lua 作为主要查找工具
- 主要快捷键：
  - `<leader><space>` - 查找文件
  - `<leader>/` - Grep 搜索
  - `<leader>,` - 切换缓冲区
  - `<leader>ff` - 查找文件
  - `<leader>fg` - Git 文件

### Markdown 支持（lua/core/autocmd.lua）

- 自定义语法高亮：待办事项、完成事项、截止日期
- 快捷键：
  - `<cr>` - 切换任务状态（`[ ]` ↔ `[x]`）
  - `<2-LeftMouse>` - 双击切换任务状态
- 日期格式：`D:YYYY-MM-DD`（截止日期）、`S:YYYY-MM-DD`（开始日期）

## 开发工作流

### 测试配置

```bash
# 启动 Neovim
nvim

# 使用 --noplugin 标志跳过插件加载
nvim --noplugin

# 调试 LemurVim 全局对象
:lua LemurVim.dump()
```

### 插件管理

```vim
:Lazy              " 打开 lazy.nvim 管理界面
:Lazy sync         " 同步插件（安装/更新/清理）
:Lazy update       " 更新插件
:Lazy clean        " 清理未使用的插件
```

### LSP 管理

```vim
:Mason             " 打开 Mason 管理界面
:LspInfo           " 查看当前缓冲区的 LSP 状态
:LspRestart        " 重启 LSP 服务器
```

### 查看快捷键

```vim
:WhichKey          " 查看所有快捷键
:map               " 查看所有键位映射
```

## 添加新插件

1. 在 `lua/plugins/` 下创建新文件（如 `new-plugin.lua`）
2. 使用标准模式定义插件：
```lua
LemurVim.plugins["new-plugin"] = {
  {
    "author/plugin-name",
    event = "VeryLazy",
    opts = {},
  },
}
```
3. 在 `lua/plugins/init.lua` 中添加 `require("plugins.new-plugin")`
4. 重启 Neovim 或执行 `:Lazy sync`

## 修改配置

- 全局选项：编辑 `lua/core/options.lua`
- 快捷键：编辑 `lua/core/keymaps.lua`
- 自动命令：编辑 `lua/core/autocmd.lua`
- 插件配置：编辑对应的 `lua/plugins/*.lua` 文件

## 注意事项

- Leader 键设置为空格键（`<space>`）
- 所有插件配置必须注册到 `LemurVim.plugins` 表中
- 使用 `LemurVim.G` 而非直接使用 `vim.api` 以保持代码一致性
- 修改配置后需要重启 Neovim 或重新加载配置
- Java 项目需要在项目根目录包含 `.git`、`pom.xml` 或 `build.gradle` 文件以正确识别项目根目录
