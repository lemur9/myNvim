# myNvim (LemurVim)

这是一个基于 `lazy.nvim` 的个人化 Neovim 配置项目，目标是构建一个开箱即用的开发环境，覆盖以下场景：

- 多语言开发（Lua/JavaScript/TypeScript/Vue/Java/C/C++/Bash 等）
- LSP 智能提示与跳转
- FZF 快速检索
- 代码高亮与格式体验优化
- Git 状态提示
- Markdown 任务流增强（待办勾选、日期高亮）

## 这个项目是干什么的

项目本质上是一个“Neovim 发行版配置”，而不是业务应用代码。  
你安装并加载它后，Neovim 会自动安装插件并应用统一的编辑体验。

核心特征：

- 以全局对象 `LemurVim` 作为配置中心
- 使用 `lazy.nvim` 进行插件管理与延迟加载
- 将配置拆分为 `core`（基础能力）和 `plugins`（插件能力）两层
- 使用 `lua/util` 提供公共工具（路径处理、根目录检测、映射封装等）

## 启动与初始化流程

入口文件是 `init.lua`，启动顺序如下：

1. `require("util")`：初始化 `LemurVim` 工具层
2. `require("core")`：加载编辑器基础设置、按键、自动命令
3. `require("plugins")`：注册插件定义
4. 调用 `lazy.setup(...)`：安装并加载插件（除 `--noplugin` 模式）

当 `lazy.nvim` 不存在时，会自动从 GitHub 克隆到本地数据目录。

## 目录结构说明

- `init.lua`：总入口，挂载 `LemurVim` 并触发 core/plugins 加载
- `lua/core/`：基础配置
  - `options.lua`：编辑器选项
  - `keymaps.lua`：按键映射
  - `autocmd.lua`：文件类型相关自动命令（重点是 Markdown 增强）
- `lua/plugins/`：插件定义（按功能拆分）
- `lua/util/`：工具函数与公共模块
  - `init.lua`：工具模块自动加载
  - `lazy.lua`：`lazy.nvim` 安装与性能配置
  - `root.lua`：项目根目录检测逻辑
  - `G.lua`：对 `vim.*` API 的封装快捷访问
- `lazy-lock.json`：插件锁定文件（保证版本可复现）

## 已集成能力（按模块）

- 代码与语法：
  - `nvim-treesitter`
  - `mason.nvim` + `mason-lspconfig.nvim` + `nvim-lspconfig`
- 补全：
  - `blink.cmp`（替代 `nvim-cmp`）
- 检索与导航：
  - `fzf-lua`
  - `neo-tree`
  - `which-key`
- 界面：
  - `lualine`
  - `bufferline`
  - `dashboard`
  - 主题模块（`theme-night`）
- 开发增强：
  - `gitsigns`
  - `snacks`
  - `indent-line`
  - Markdown 预览、翻译、中文帮助文档等

## 环境要求（建议）

- Neovim 0.10+（建议 0.10/0.11）
- Git（首次拉取 `lazy.nvim`）
- `ripgrep`（已在配置中用于搜索）
- Node.js（部分 LSP/插件依赖）
- Java（如果使用 `jdtls`）
- Nerd Font（图标显示更完整）

## 快速使用

1. 将本仓库作为你的 Neovim 配置目录（`stdpath("config")`）
2. 启动 `nvim`
3. 等待首次自动安装插件
4. 常用命令：
   - `:Lazy` 查看插件状态
   - `:Mason` 管理 LSP/工具

## 维护建议

- 新增插件：在 `lua/plugins/` 新建模块并在 `lua/plugins/init.lua` 中注册
- 调整全局行为：优先修改 `lua/core/options.lua` 与 `lua/core/keymaps.lua`
- 固定插件版本：更新后同步维护 `lazy-lock.json`

## 当前代码中的注意点

- `lua/plugins/lsp.lua` 中存在 `capabilities` 变量的引用，但其定义被注释，建议补充或移除对应字段，避免运行时报错。
- `core/keymaps.lua` 里有 Telescope 相关映射，但插件列表当前以 `fzf-lua` 为主，若未安装 Telescope，相关映射会不可用。
